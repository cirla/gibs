port module Session exposing (..)

import Json.Decode exposing (Decoder, field, string, succeed)
import Json.Decode.Extra exposing ((|:))


type alias Session =
    { token : String
    }


port setSession : Session -> Cmd msg


decodeSession : Decoder Session
decodeSession =
    succeed Session
        |: (field "token" string)
