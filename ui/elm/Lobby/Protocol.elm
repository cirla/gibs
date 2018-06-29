module Lobby.Protocol exposing (connect, decode, say, wsUrl)

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


connect : Location -> String -> Cmd msg
connect location token =
    Json.object
        [ ( "connect"
          , Json.object
                [ ( "token", Json.string token ) ]
          )
        ]
        |> send location


say : Location -> String -> Cmd msg
say location message =
    Json.object
        [ ( "say"
          , Json.object
                [ ( "body", Json.string message ) ]
          )
        ]
        |> send location


send : Location -> Json.Value -> Cmd msg
send location payload =
    WebSocket.send (wsUrl location) (Json.encode 0 payload)


wsUrl : Location -> String
wsUrl location =
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
            , "/ws"
            ]
