module Login.Types exposing (..)

import Http
import Session exposing (Session)


type alias Model =
    { username : String
    , password : String
    }


type Msg
    = Login
    | LoginResponse (Result Http.Error Response)
    | Password String
    | Username String


type Response
    = Session Session
    | Error String
