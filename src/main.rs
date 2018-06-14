#[macro_use]
extern crate actix;
extern crate actix_web;
extern crate clap;
extern crate config;
extern crate env_logger;
extern crate futures;
#[macro_use]
extern crate log;
#[macro_use]
extern crate serde_derive;

mod game;
mod lobby;
mod server;
mod settings;

use clap::{App, Arg};

use server::Server;
use settings::Settings;

fn main() -> Result<(), settings::Error> {
    env_logger::init();

    let matches = App::new("GNU Internet Backgammon Server")
        .arg(
            Arg::with_name("config")
                .short("c")
                .long("config")
                .value_name("FILE")
                .help("config file")
                .takes_value(true),
        )
        .get_matches();

    let settings = Settings::new(matches)?;
    info!("Settings: {:?}", settings);

    Server::with_settings(settings).start();

    Ok(())
}
