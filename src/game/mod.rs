mod gnubg;

pub trait Game {
    type PlayerId;

    fn roll(p: Self::PlayerId);
}

pub trait GameManager {
    type PlayerId;
    type Game: Game<PlayerId = Self::PlayerId>;

    fn new_game(self, p1: Self::PlayerId, p2: Self::PlayerId) -> Self::Game;
}
