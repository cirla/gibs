module Lobby.State exposing (..)

import Session exposing (..)
import Lobby.Types exposing (..)


initialModel : Model
initialModel =
    { session = Nothing
    }


init : Maybe String -> ( Model, Cmd Msg )
init session =
    ( { initialModel | session = Maybe.andThen parseSession session }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SessionData data ->
            ( { model | session = parseSession data }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
