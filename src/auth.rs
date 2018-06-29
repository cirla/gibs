use actix_web::{self, HttpRequest, HttpResponse, Json, Responder, State};
use actix_web::http::{StatusCode};
use argon2rs::verifier::Encoded;
use diesel::prelude::*;
use jwt;

use models::User;
use server;

#[derive(Deserialize)]
pub struct Login {
    username: String,
    password: String,
}

#[derive(Serialize)]
pub struct Claims {
    username: String,
}

#[derive(Serialize)]
pub struct Session {
    username: String,
    token: String,
}

#[derive(Serialize)]
pub struct Error {
    message: String,
    #[serde(skip_serializing)]
    status: StatusCode,
}

pub enum LoginResponse {
    Session(Session),
    Error(Error),
}

impl Responder for LoginResponse {
    type Item = HttpResponse;
    type Error = actix_web::Error;

    fn respond_to<S>(self, _req: &HttpRequest<S>) -> Result<HttpResponse, actix_web::Error> {
        let res = match self {
            LoginResponse::Session(s) =>
                HttpResponse::Ok().json(s),
            LoginResponse::Error(e) =>
                HttpResponse::build(e.status).json(e),
        };

        Ok(res)
    }
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
        return LoginResponse::Error(Error {
            message: "username not found".to_string(),
            status: StatusCode::BAD_REQUEST,
        });
    }

    let res = &res[0];

    let enc = Encoded::from_u8(&res.password_hash.as_str().as_bytes()).unwrap();
    if !enc.verify(&login.password.as_str().as_bytes()) {
        return LoginResponse::Error(Error {
            message: "invalid password".to_string(),
            status: StatusCode::UNAUTHORIZED,
        });
    }

    let claims = Claims { username: res.username.clone() };
    let token = jwt::encode(&jwt::Header::default(), &claims, state.secret.as_ref()).unwrap();

    LoginResponse::Session(Session {
        username: claims.username,
        token: token,
    })
}
