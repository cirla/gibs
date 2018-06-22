module Lobby.Types exposing (..)

import Login.Types
import Session exposing (Session)


type alias Model =
    { login : Login.Types.Model
    , session : Maybe Session
    , events : List Event
    }


type Event
    = Connected String
    | Disconnected String
    | Message String String


type Msg
    = LoginMsg Login.Types.Msg
    | IncomingMsg String
