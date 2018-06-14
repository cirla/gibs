use actix::{Addr, Arbiter, Syn, System, SystemRunner};
use actix_web::server::HttpServer;
use actix_web::App;

use lobby::{lobby_route, Lobby};
use settings::Settings;

pub struct State {
    pub lobby_addr: Addr<Syn, Lobby>,
}

pub struct Server {
    sys: SystemRunner,
}

impl Server {
    pub fn with_settings(s: Settings) -> Self {
        let sys = System::new("gibs");
        let lobby: Addr<Syn, _> = Arbiter::start(|_| Lobby::new());

        HttpServer::new(move || {
            let state = State {
                lobby_addr: lobby.clone(),
            };

            App::with_state(state).resource("/", |r| r.route().f(lobby_route))
        }).bind(format!("{}:{}", s.server.host, s.server.port))
            .expect("Could not bind to host/port.")
            .start();

        Self { sys: sys }
    }

    pub fn start(self) {
        info!("Starting server");
        self.sys.run();
    }
}
