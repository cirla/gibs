use actix_web::{Json, Responder, State};
use argon2rs::verifier::Encoded;
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
        // TODO: error code
        return Json(Response::Error(Error {
            message: "username not found".to_string(),
        }));
    }

    let res = &res[0];

    let enc = Encoded::from_u8(&res.password_hash.as_str().as_bytes()).unwrap();
    if !enc.verify(&login.password.as_str().as_bytes()) {
        // TODO: error code
        return Json(Response::Error(Error {
            message: "invalid password".to_string(),
        }));
    }

    Json(Response::Session(Session {
        username: res.username.clone(),
        token: "abc123".to_string(),
    }))
}
