module Types exposing (..)

import Lobby.Types
import Nav exposing (Route)
import Navigation exposing (Location)


type alias Model =
    { route : Maybe Route
    , lobby : Lobby.Types.Model
    }


type Msg
    = UrlChange Location
    | LobbyMsg Lobby.Types.Msg
