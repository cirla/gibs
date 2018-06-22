module Lobby.Protocol exposing (connect, decode, say)

import Json.Decode exposing (Decoder, field, oneOf, string, succeed)
import Json.Decode.Extra exposing ((|:))
import Json.Encode as Json
import Lobby.Types exposing (..)
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


connect : String -> Cmd msg
connect token =
    Json.object
        [ ( "connect"
          , Json.object
                [ ( "token", Json.string token ) ]
          )
        ]
        |> send


say : String -> Cmd msg
say message =
    Json.object
        [ ( "say"
          , Json.object
                [ ( "body", Json.string message ) ]
          )
        ]
        |> send


send : Json.Value -> Cmd msg
send payload =
    WebSocket.send "ws://localhost:8081/ws" (Json.encode 0 payload)
