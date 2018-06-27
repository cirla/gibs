use actix::*;
use actix_web::server::HttpServer;
use actix_web::{fs, http, App, HttpResponse};
use diesel::pg::PgConnection;
use r2d2::Pool;
use r2d2_diesel::ConnectionManager;

use auth::login_route;
use lobby::{lobby_route, Lobby};
use settings::Settings;

pub struct State {
    pub lobby_addr: Addr<Syn, Lobby>,
    pub conn_pool: Pool<ConnectionManager<PgConnection>>,
}

pub struct Server {
    sys: SystemRunner,
}

impl Server {
    pub fn with_settings(s: Settings) -> Self {
        let sys = System::new("gibs");

        let max_users = s.lobby.max_users;
        let lobby: Addr<Syn, _> = Arbiter::start(move |_| Lobby::new(max_users));

        let conn_mgr = ConnectionManager::<PgConnection>::new(s.db.postgres.url);
        let conn_pool = Pool::builder()
            .build(conn_mgr)
            .expect("Failed to create database connection pool.");

        HttpServer::new(move || {
            let state = State {
                lobby_addr: lobby.clone(),
                conn_pool: conn_pool.clone(),
            };

            App::with_state(state)
                .resource("/", |r| {
                    r.method(http::Method::GET).f(|_| {
                        HttpResponse::Found()
                            .header("LOCATION", "/static/index.html")
                            .finish()
                    })
                })
                .resource("/login", |r| r.method(http::Method::POST).with(login_route))
                .resource("/ws", |r| r.route().f(lobby_route))
                .handler("/static/", fs::StaticFiles::new("dist/"))
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
