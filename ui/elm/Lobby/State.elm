module Lobby.State exposing (..)

import Json.Decode exposing (decodeString)
import Lobby.Types exposing (..)
import Login.State
import Login.Types
import Maybe.Extra exposing (join)
import Session exposing (..)
import WebSocket exposing (listen, send)


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
        Connect token ->
            ( model, Cmd.none )

        Disconnect ->
            ( model, Cmd.none )

        IncomingMsg incMsg ->
            handleIncoming incMsg model

        LoginMsg loginMsg ->
            updateLogin loginMsg model

        Say sayMsg ->
            ( model, Cmd.none )


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


connect : String -> Cmd Msg
connect token =
    -- TODO: move to a Protocol.elm and use JSON encoding/decoding
    send "ws://localhost:8081/ws" ("{\"connect\": \"" ++ token ++ "\"}")


subscriptions : Model -> Sub Msg
subscriptions model =
    listen "ws://localhost:8081/ws" IncomingMsg
