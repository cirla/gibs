module Lobby.View exposing (root)

import Html exposing (Html, button, div, form, i, input, li, p, text, ul)
import Html.Attributes exposing (class, id, type_, value)
import Html.Attributes.Aria exposing (role)
import Html.Events exposing (onInput, onSubmit)
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
        , inputGroup model.input
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

            Error msg ->
                text ("Error: " ++ msg)
        ]


inputGroup : String -> Html Msg
inputGroup model =
    form [ onSubmit Submit ]
        [ div [ class "form-group" ]
            [ input [ class "form-control", id "inputText", value model, onInput Input ] []
            , button
                [ class "btn btn-primary", type_ "submit" ]
                [ text "Submit" ]
            ]
        ]
