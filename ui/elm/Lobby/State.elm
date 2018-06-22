module Lobby.State exposing (..)

import Json.Decode exposing (decodeString)
import Lobby.Types exposing (..)
import Login.State
import Login.Types
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
            updateLogin loginMsg model


updateLogin : Login.Types.Msg -> Model -> ( Model, Cmd Msg )
updateLogin msg model =
    case msg of
        Login.Types.LoginResponse res ->
            case res of
                Ok session ->
                    ( { model | session = Just session }, setSession session )

                Err e ->
                    -- TODO: Handle Error
                    ( model, Cmd.none )

        _ ->
            let
                ( login, loginCmd ) =
                    Login.State.update msg model.login
            in
                ( { model | login = login }, Cmd.map LoginMsg loginCmd )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
