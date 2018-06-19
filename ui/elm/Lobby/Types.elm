module Lobby.Types exposing (..)

import Login.Types
import Session exposing (Session)


type alias Model =
    { login : Login.Types.Model
    , session : Maybe Session
    }


type Msg
    = LoginMsg Login.Types.Msg
