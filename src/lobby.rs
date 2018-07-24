use std::collections::HashMap;
use std::time::Instant;

use actix::*;
use actix_web::{self, ws, HttpRequest, HttpResponse, Query};
use serde_json;

use auth::verify_token;
use models::User;
use server::State;

#[derive(Message)]
#[rtype(result = "Result<(), String>")]
pub struct Connect {
    pub id: i32,
    pub addr: Recipient<Syn, Outgoing>,
}

#[derive(Message)]
pub struct Disconnect {
    pub id: i32,
}

pub struct Lobby {
    max_sessions: usize,
    sessions: HashMap<i32, Recipient<Syn, Outgoing>>,
}

impl Lobby {
    pub fn new(max_sessions: usize) -> Self {
        Self {
            max_sessions: max_sessions,
            sessions: HashMap::new(),
        }
    }
}

impl Actor for Lobby {
    type Context = Context<Self>;
}

impl Handler<Connect> for Lobby {
    type Result = Result<(), String>;

    fn handle(&mut self, msg: Connect, _ctx: &mut Context<Self>) -> Self::Result {
        if self.sessions.len() == self.max_sessions {
            return Err("Too many users!".to_string());
        }

        for (_, session) in &self.sessions {
            let _ = session.do_send(Outgoing::Connected(Connected {
                username: msg.id.to_string(),
            }));
        }

        self.sessions.insert(msg.id, msg.addr);
        Ok(())
    }
}

impl Handler<Disconnect> for Lobby {
    type Result = ();

    fn handle(&mut self, msg: Disconnect, _: &mut Context<Self>) {
        self.sessions.remove(&msg.id);

        for (_, session) in &self.sessions {
            let _ = session.do_send(Outgoing::Disconnected(Disconnected {
                username: msg.id.to_string(),
            }));
        }
    }
}

#[derive(Deserialize)]
struct Say {
    message: String,
}

#[derive(Deserialize)]
enum Incoming {
    #[serde(rename = "say")]
    Say(Say),
}

#[derive(Serialize)]
pub struct Connected {
    username: String,
}

#[derive(Serialize)]
pub struct Disconnected {
    username: String,
}

#[derive(Serialize)]
pub struct Error {
    message: String,
}

#[derive(Serialize)]
pub struct ChatMessage {
    username: String,
    body: String,
}

#[derive(Message, Serialize)]
pub enum Outgoing {
    #[serde(rename = "connected")]
    Connected(Connected),
    #[serde(rename = "disconnected")]
    Disconnected(Disconnected),
    #[serde(rename = "error")]
    Error(Error),
    #[serde(rename = "message")]
    Message(ChatMessage),
}

struct LobbySession {
    hb: Instant,
    user: User,
}

impl LobbySession {
    fn handle_text(&mut self, text: String) -> Result<Outgoing, serde_json::Error> {
        let incoming: Incoming = serde_json::from_str(&text)?;
        match incoming {
            Incoming::Say(say) => Ok(self.handle_say(say.message)),
        }
    }

    fn handle_say(&self, message: String) -> Outgoing {
        Outgoing::Message(ChatMessage {
            username: self.user.username.clone(),
            body: message,
        })
    }
}

impl Actor for LobbySession {
    type Context = ws::WebsocketContext<Self, State>;

    fn started(&mut self, ctx: &mut Self::Context) {
        let addr: Addr<Syn, _> = ctx.address();
        ctx.state()
            .lobby_addr
            .send(Connect {
                id: self.user.id,
                addr: addr.recipient(),
            })
            .into_actor(self)
            .then(|res, _act, ctx| {
                match res {
                    Ok(Ok(())) => (),
                    Ok(Err(err)) => ctx.text(err),
                    _ => ctx.stop(),
                }
                fut::ok(())
            })
            .wait(ctx);
    }

    fn stopping(&mut self, ctx: &mut Self::Context) -> Running {
        ctx.state()
            .lobby_addr
            .do_send(Disconnect { id: self.user.id });
        Running::Stop
    }
}

impl Handler<Outgoing> for LobbySession {
    type Result = ();

    fn handle(&mut self, msg: Outgoing, ctx: &mut Self::Context) {
        ctx.text(serde_json::to_string(&msg).unwrap());
    }
}

impl StreamHandler<ws::Message, ws::ProtocolError> for LobbySession {
    fn handle(&mut self, msg: ws::Message, ctx: &mut Self::Context) {
        match msg {
            ws::Message::Ping(msg) => ctx.pong(&msg),
            ws::Message::Pong(_) => self.hb = Instant::now(),
            ws::Message::Text(text) => match self.handle_text(text) {
                Ok(ref res) => ctx.text(serde_json::to_string(res).unwrap()),
                Err(e) => {
                    error!("{}", e.to_string());
                    ctx.text(
                        serde_json::to_string(&Outgoing::Error(Error {
                            message: e.to_string(),
                        })).unwrap(),
                    )
                }
            },
            ws::Message::Binary(_) => info!("Unexpected binary"),
            ws::Message::Close(_) => ctx.stop(),
        }
    }
}

#[derive(Deserialize)]
pub struct ConnectParams {
    token: String,
}

pub fn lobby_route(
    data: (HttpRequest<State>, Query<ConnectParams>),
) -> Result<HttpResponse, actix_web::Error> {
    let (req, params) = data;

    let token = params.token.clone();
    let conn = req.state().conn_pool.get().unwrap();
    let secret = req.state().secret.clone();

    match verify_token(conn, secret, token) {
        // TODO: check if user already connected
        Ok(user) => ws::start(
            req,
            LobbySession {
                hb: Instant::now(),
                user: user,
            },
        ),
        Err(e) => {
            error!("{}", e.message);
            Ok(HttpResponse::build(e.status).json(e))
        }
    }
}
