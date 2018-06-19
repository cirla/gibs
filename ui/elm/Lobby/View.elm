module Lobby.View exposing (root)

import Html exposing (Html, div, p, text)
import Lobby.Types exposing (..)
import Login.View
import Session exposing (Session)


root : Model -> Html Msg
root model =
    case model.session of
        Just session ->
            viewLobby session

        Nothing ->
            Html.map LoginMsg Login.View.root


viewLobby : Session -> Html Msg
viewLobby session =
    div []
        [ p []
            [ text <| "Welcome, " ++ session.username ++ "!"
            ]
        ]
