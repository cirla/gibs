use actix_web::{Json, Responder};

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

pub fn login_route(data: Json<Login>) -> impl Responder {
    Json(Session {
        username: data.username.clone(),
        token: "abc123".to_string(),
    })
}
