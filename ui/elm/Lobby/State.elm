module Lobby.State exposing (..)

import Json.Decode exposing (decodeString)
import Lobby.Types exposing (..)
import Maybe.Extra exposing (join)
import Session exposing (..)


init : Maybe String -> ( Model, Cmd Msg )
init session =
    let
        res =
            Maybe.map (decodeString decodeSession) session
    in
        ( { session = Maybe.map Result.toMaybe res |> join
          }
        , Cmd.none
        )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Foo ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
