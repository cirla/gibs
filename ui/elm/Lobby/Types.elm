module Lobby.Types exposing (..)

import Login.Types
import Navigation exposing (Location)
import Session exposing (Session)


type alias Model =
    { error : Maybe String
    , login : Login.Types.Model
    , session : Maybe Session
    , location : Location
    , events : List Event
    }


type Event
    = Connected String
    | Disconnected String
    | Message String String


type Msg
    = LoginMsg Login.Types.Msg
    | IncomingMsg String
