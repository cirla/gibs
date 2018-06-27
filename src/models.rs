use chrono::{NaiveDateTime};

use schema::users;

#[derive(Identifiable, Queryable)]
pub struct User {
    pub id: i32,
    pub username: String,
    pub email: String,
    pub password_hash: String,
    pub created_at: NaiveDateTime,
    pub elo: i16,
}
