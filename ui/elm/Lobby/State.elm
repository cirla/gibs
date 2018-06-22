module Lobby.State exposing (..)

import Json.Decode exposing (decodeString)
import Lobby.Protocol exposing (..)
import Lobby.Types exposing (..)
import Login.State
import Login.Types
import Maybe.Extra exposing (join)
import Session exposing (..)
import WebSocket exposing (listen)


init : Maybe String -> ( Model, Cmd Msg )
init session =
    let
        res =
            Maybe.map (decodeString decodeSession) session

        model =
            { login = Login.State.init
            , session = Maybe.map Result.toMaybe res |> join
            , events = []
            }
    in
        ( model
        , case model.session of
            Just s ->
                connect s.token

            Nothing ->
                Cmd.none
        )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        IncomingMsg incMsg ->
            handleIncoming incMsg model

        LoginMsg loginMsg ->
            updateLogin loginMsg model


handleIncoming : String -> Model -> ( Model, Cmd Msg )
handleIncoming msg model =
    ( model, Cmd.none )


updateLogin : Login.Types.Msg -> Model -> ( Model, Cmd Msg )
updateLogin msg model =
    case msg of
        Login.Types.LoginResponse res ->
            case res of
                Ok session ->
                    { model | session = Just session } ! [ setSession session, connect session.token ]

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
    listen "ws://localhost:8081/ws" IncomingMsg
