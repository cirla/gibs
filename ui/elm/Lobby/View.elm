module Lobby.View exposing (root)

import Html exposing (Html, div, i, li, p, text, ul)
import Html.Attributes exposing (class)
import Html.Attributes.Aria exposing (role)
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


error : String -> Html Msg
error e =
    div [ class "alert alert-danger", role "alert" ]
        [ i [ class "fas fa-exclamation-circle" ] []
        , text e
        ]


viewLobby : Session -> Model -> Html Msg
viewLobby session model =
    let
        errorDiv =
            Maybe.map (error >> List.singleton) model.error
                |> Maybe.withDefault []
    in
        div []
            (errorDiv
                ++ [ p []
                        [ text <| "Welcome, " ++ session.username ++ "!"
                        ]
                   , ul [ class "list-group" ] (List.map viewEvent model.events)
                   ]
            )


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
