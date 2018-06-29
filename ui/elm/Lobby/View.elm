module Lobby.View exposing (root)

import Html exposing (Html, div, li, p, text, ul)
import Html.Attributes exposing (class)
import Lobby.Types exposing (..)
import Login.View
import Session exposing (Session)


root : Model -> Html Msg
root model =
    case model.session of
        Just session ->
            viewLobby session model

        Nothing ->
            Html.map LoginMsg (Login.View.root model.login)


viewLobby : Session -> Model -> Html Msg
viewLobby session model =
    div []
        [ p []
            [ text <| "Welcome, " ++ session.username ++ "!"
            ]
        , ul [ class "list-group" ] (List.map viewEvent model.events)
        ]


viewEvent : Event -> Html Msg
viewEvent event =
    li [ class "list-group-item" ]
        [ case event of
            Connected user ->
                text (user ++ " connected")

            Disconnected user ->
                text (user ++ " disconnected")

            Message user msg ->
                text (user ++ ": " ++ msg)
        ]
