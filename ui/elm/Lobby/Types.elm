module Lobby.Types exposing (..)

import Session exposing (Session)


type alias Model =
    { session : Maybe Session
    }


type Msg
    = Foo
