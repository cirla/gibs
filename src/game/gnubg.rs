use std::path::Path;
use std::process::{Child, Command};

use super::{Game, GameManager};

pub struct Gnubg<'a> {
    proc: &'a Child,
}

impl<'a> Game for Gnubg<'a> {
    type PlayerId = String;

    fn roll(_: Self::PlayerId) {}
}

pub struct GnubgManager {
    procs: Vec<Child>,
}

impl GnubgManager {
    pub fn new(max_procs: usize, path: String) -> Self {
        let prog = Path::new(&path).join("gnubg");
        let mut procs = Vec::new();

        for _ in 0..max_procs {
            procs.push(
                Command::new(&prog)
                    .args(&["--tty", "--quiet"])
                    .spawn()
                    .expect("failed to spawn proc"),
            );
        }

        Self { procs: procs }
    }
}

impl<'a> GameManager for &'a GnubgManager {
    type PlayerId = String;
    type Game = Gnubg<'a>;

    fn new_game(self, _p1: Self::PlayerId, _p2: Self::PlayerId) -> Self::Game {
        Gnubg {
            proc: &self.procs[0],
        }
    }
}
