module Login.Types exposing (..)

import Http
import Session exposing (Session)


type alias Model =
    { username : String
    , password : String
    , error : Maybe Http.Error
    }


type Msg
    = Login
    | LoginResponse (Result Http.Error Session)
    | Password String
    | Username String
