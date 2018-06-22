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
            -- Handled by parent
            ( model, Cmd.none )

        Password p ->
            ( { model | password = p }, Cmd.none )

        Username u ->
            ( { model | username = u }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
