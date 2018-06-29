module Login.Api exposing (login)

import Http
import Json.Encode as Json
import Login.Types exposing (..)
import Session exposing (decodeSession)


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
        Http.send LoginResponse (Http.post "/login" body decodeSession)
