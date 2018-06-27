use clap::ArgMatches;
use config::{Config, ConfigError, Environment, File};

pub type Error = ConfigError;

#[derive(Debug, Deserialize)]
pub struct Server {
    pub debug: bool,
    pub host: String,
    pub port: u16,
}

#[derive(Debug, Deserialize)]
pub struct Lobby {
    pub max_users: usize,
}

#[derive(Debug, Deserialize)]
pub struct Postgres {
    pub url: String,
}

#[derive(Debug, Deserialize)]
pub struct Database {
    pub postgres: Postgres,
}

#[derive(Debug, Deserialize)]
pub struct Gnubg {
    pub path: String,
}

#[derive(Debug, Deserialize)]
pub struct Game {
    pub max_games: usize,
    pub gnubg: Gnubg,
}

#[derive(Debug, Deserialize)]
pub struct Settings {
    pub server: Server,
    pub lobby: Lobby,
    pub db: Database,
    pub game: Game,
}

impl Settings {
    pub fn new(matches: ArgMatches) -> Result<Self, ConfigError> {
        let mut c = Config::new();

        match matches.value_of("config") {
            Some(config_file) => {
                c.merge(File::with_name(config_file))?;
            }
            None => {}
        }

        c.merge(Environment::with_prefix("gibs"))?;

        c.try_into()
    }
}
