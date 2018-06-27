module Login.Api exposing (login)

import Http
import Json.Decode exposing (Decoder, at, field, oneOf, string, succeed)
import Json.Decode.Extra exposing ((|:))
import Json.Encode as Json
import Login.Types exposing (..)
import Session exposing (decodeSession)


decodeResponse : Decoder Response
decodeResponse =
    oneOf
        [ succeed Session
            |: field "session" decodeSession
        , succeed Error
            |: at [ "error", "message" ] string
        ]


login : Model -> Cmd Msg
login req =
    let
        body =
            Json.object
                [ ( "username", Json.string req.username )
                , ( "password", Json.string req.password )
                ]
                |> Http.jsonBody
    in
        Http.send LoginResponse (Http.post "/login" body decodeResponse)
