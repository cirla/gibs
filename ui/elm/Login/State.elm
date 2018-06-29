module Login.State exposing (..)

import Login.Api exposing (..)
import Login.Types exposing (..)


init : Model
init =
    { username = ""
    , password = ""
    , error = Nothing
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Login ->
            model ! [ login model ]

        LoginResponse res ->
            case res of
                Err e ->
                    { model | error = Just e } ! []

                _ ->
                    { model | error = Nothing } ! []

        Password p ->
            { model | password = p } ! []

        Username u ->
            { model | username = u } ! []
