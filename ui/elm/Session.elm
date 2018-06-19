port module Session exposing (..)

import Json.Decode exposing (Decoder, field, string, succeed)
import Json.Decode.Extra exposing ((|:))


type alias Session =
    { username : String
    , token : String
    }


port setSession : Session -> Cmd msg


decodeSession : Decoder Session
decodeSession =
    succeed Session
        |: (field "username" string)
        |: (field "token" string)
