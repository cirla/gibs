module Nav exposing (..)

import Navigation
import UrlParser as Url


type Route
    = Lobby
    | About


toHash : Route -> String
toHash route =
    case route of
        Lobby ->
            "#"

        About ->
            "#about"


route : Url.Parser (Route -> a) a
route =
    Url.oneOf
        [ Url.map Lobby Url.top
        , Url.map About (Url.s "about")
        ]


parseRoute : Navigation.Location -> Maybe Route
parseRoute =
    Url.parseHash route
