module Lobby.Types exposing (..)

import Login.Types
import Navigation exposing (Location)
import Session exposing (Session)


type alias Model =
    { login : Login.Types.Model
    , session : Maybe Session
    , location : Location
    , events : List Event
    }


type Event
    = Connected String
    | Disconnected String
    | Message String String
    | Error String


type Msg
    = LoginMsg Login.Types.Msg
    | IncomingMsg String
