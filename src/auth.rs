use actix_web::{Json, Responder, State};
use diesel::prelude::*;

use models::User;
use server;

#[derive(Deserialize)]
pub struct Login {
    username: String,
    password: String,
}

#[derive(Serialize)]
pub struct Session {
    username: String,
    token: String,
}

#[derive(Serialize)]
pub struct Error {
    message: String,
}

#[derive(Serialize)]
pub enum Response {
    #[serde(rename = "session")]
    Session(Session),
    #[serde(rename = "error")]
    Error(Error),
}

pub fn login_route(data: (State<server::State>, Json<Login>)) -> impl Responder {
    use schema::users::dsl::*;

    let (state, login) = data;

    let conn = state.conn_pool.get().unwrap();
    let res = users
        .filter(username.eq(&login.username))
        .load::<User>(&*conn)
        .unwrap();

    if res.is_empty() {
        return Json(Response::Error(Error {
            message: "Error".to_string(),
        }));
    }

    Json(Response::Session(Session {
        username: res[0].username.clone(),
        token: "abc123".to_string(),
    }))
}
