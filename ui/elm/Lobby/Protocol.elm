module Lobby.Protocol exposing (decode, say, wsUrl)

import Json.Decode exposing (Decoder, field, oneOf, string, succeed)
import Json.Decode.Extra exposing ((|:))
import Json.Encode as Json
import Lobby.Types exposing (..)
import Navigation exposing (Location)
import WebSocket


decode : Decoder Event
decode =
    oneOf
        [ field "connected" decodeConnected
        , field "disconnected" decodeDisconnected
        , field "message" decodeMessage
        , field "error" decodeError
        ]


decodeConnected : Decoder Event
decodeConnected =
    succeed Connected
        |: field "username" string


decodeDisconnected : Decoder Event
decodeDisconnected =
    succeed Disconnected
        |: field "username" string


decodeMessage : Decoder Event
decodeMessage =
    succeed Message
        |: field "username" string
        |: field "body" string


decodeError : Decoder Event
decodeError =
    succeed Error
        |: field "message" string


say : Location -> String -> String -> Cmd msg
say location token message =
    Json.object
        [ ( "say"
          , Json.object
                [ ( "body", Json.string message ) ]
          )
        ]
        |> send location token


send : Location -> String -> Json.Value -> Cmd msg
send location token payload =
    WebSocket.send (wsUrl location token) (Json.encode 0 payload)


wsUrl : Location -> String -> String
wsUrl location token =
    let
        protocol =
            if (String.contains "https" location.protocol) then
                "wss"
            else
                "ws"
    in
        String.concat
            [ protocol
            , "://"
            , location.host
            , "/ws?token="
            , token
            ]
