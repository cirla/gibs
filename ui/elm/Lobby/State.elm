module Lobby.State exposing (..)

import Json.Decode exposing (decodeString)
import Lobby.Protocol exposing (..)
import Lobby.Types exposing (..)
import Login.State
import Login.Types
import Maybe.Extra exposing (join)
import Navigation exposing (Location)
import Session exposing (..)
import WebSocket exposing (listen)


init : Location -> Maybe String -> ( Model, Cmd Msg )
init location session =
    let
        res =
            Maybe.map (decodeString decodeSession) session

        model =
            { error = Nothing
            , login = Login.State.init
            , session = Maybe.map Result.toMaybe res |> join
            , location = location
            , events = []
            }
    in
        model ! (Maybe.withDefault [] <| Maybe.map (.token >> connect model.location >> List.singleton) model.session)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        IncomingMsg incMsg ->
            handleIncoming incMsg model

        LoginMsg loginMsg ->
            updateLogin loginMsg model


handleIncoming : String -> Model -> ( Model, Cmd Msg )
handleIncoming msg model =
    let
        res =
            decodeString Lobby.Protocol.decode msg
    in
        case res of
            Ok event ->
                { model | events = event :: model.events } ! []

            Err e ->
                { model | error = Just e } ! []


updateLogin : Login.Types.Msg -> Model -> ( Model, Cmd Msg )
updateLogin msg model =
    case msg of
        Login.Types.LoginResponse (Ok session) ->
            { model | session = Just session } ! [ setSession session, connect model.location session.token ]

        _ ->
            let
                ( login, loginCmd ) =
                    Login.State.update msg model.login
            in
                { model | login = login } ! [ Cmd.map LoginMsg loginCmd ]


subscriptions : Model -> Sub Msg
subscriptions model =
    case model.session of
        Just s ->
            listen (wsUrl model.location) IncomingMsg

        Nothing ->
            Sub.none
