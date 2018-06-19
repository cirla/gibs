module Lobby.State exposing (..)

import Lobby.Types exposing (..)


initialModel : Model
initialModel =
    { foo = True
    }


init : ( Model, Cmd Msg )
init =
    ( initialModel
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Foo ->
            ( model, Cmd.none )
