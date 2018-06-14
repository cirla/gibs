use std::collections::HashMap;
use std::time::Instant;

use actix::*;
use actix_web::{ws, Error, HttpRequest, HttpResponse};

use server::State;

#[derive(Message)]
pub struct Message(pub String);

#[derive(Message)]
#[rtype(usize)]
pub struct Connect {
    pub addr: Recipient<Syn, Message>,
}

/// Session is disconnected
#[derive(Message)]
pub struct Disconnect {
    pub id: usize,
}

pub struct Lobby {
    sessions: HashMap<usize, Recipient<Syn, Message>>,
}

impl Lobby {
    pub fn new() -> Self {
        Self {
            sessions: HashMap::new(),
        }
    }
}

impl Actor for Lobby {
    type Context = Context<Self>;
}

impl Handler<Connect> for Lobby {
    type Result = usize;

    fn handle(&mut self, msg: Connect, _: &mut Context<Self>) -> Self::Result {
        info!("New connection");
        let id = 0;

        self.sessions.insert(id, msg.addr);

        id
    }
}

impl Handler<Disconnect> for Lobby {
    type Result = ();

    fn handle(&mut self, msg: Disconnect, _: &mut Context<Self>) {
        info!("{} disconnected", &msg.id);
        self.sessions.remove(&msg.id);
    }
}

struct LobbySession {
    id: usize,
    hb: Instant,
    //user: Option<User>,
}

impl Actor for LobbySession {
    type Context = ws::WebsocketContext<Self, State>;

    fn started(&mut self, ctx: &mut Self::Context) {
        let addr: Addr<Syn, _> = ctx.address();
        ctx.state()
            .lobby_addr
            .send(Connect {
                addr: addr.recipient(),
            })
            .into_actor(self)
            .then(|res, act, ctx| {
                match res {
                    Ok(res) => act.id = res,
                    _ => ctx.stop(),
                }
                fut::ok(())
            })
            .wait(ctx);
    }

    fn stopping(&mut self, ctx: &mut Self::Context) -> Running {
        ctx.state().lobby_addr.do_send(Disconnect { id: self.id });
        Running::Stop
    }
}

impl Handler<Message> for LobbySession {
    type Result = ();

    fn handle(&mut self, msg: Message, ctx: &mut Self::Context) {
        ctx.text(msg.0);
    }
}

impl StreamHandler<ws::Message, ws::ProtocolError> for LobbySession {
    fn handle(&mut self, msg: ws::Message, ctx: &mut Self::Context) {
        println!("WEBSOCKET MESSAGE: {:?}", msg);
        match msg {
            ws::Message::Ping(msg) => ctx.pong(&msg),
            ws::Message::Pong(_) => self.hb = Instant::now(),
            ws::Message::Text(text) => {
                println!("Received: {}", text);
            }
            ws::Message::Binary(_) => println!("Unexpected binary"),
            ws::Message::Close(_) => {
                ctx.stop();
            }
        }
    }
}

pub fn lobby_route(req: HttpRequest<State>) -> Result<HttpResponse, Error> {
    ws::start(
        req,
        LobbySession {
            id: 0,
            hb: Instant::now(),
        },
    )
}
