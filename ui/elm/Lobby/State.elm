module Lobby.State exposing (..)

import Json.Decode exposing (decodeString)
import Lobby.Types exposing (..)
import Login.State
import Maybe.Extra exposing (join)
import Session exposing (..)


init : Maybe String -> ( Model, Cmd Msg )
init session =
    let
        res =
            Maybe.map (decodeString decodeSession) session
    in
        ( { login = Login.State.init
          , session = Maybe.map Result.toMaybe res |> join
          }
        , Cmd.none
        )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LoginMsg loginMsg ->
            let
                ( login, loginCmd ) =
                    Login.State.update loginMsg model.login
            in
                ( { model | login = login }, Cmd.map LoginMsg loginCmd )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
