module Login.State exposing (..)

import Login.Api exposing (..)
import Login.Types exposing (..)


init : Model
init =
    { username = ""
    , password = ""
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Login ->
            ( model, login model )

        LoginResponse res ->
            -- TODO: set session from response; handle error
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
