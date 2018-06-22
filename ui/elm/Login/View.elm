module Login.View exposing (root)

import Html exposing (Html, button, div, form, input, label, p, text)
import Html.Attributes exposing (class, for, id, type_)
import Html.Events exposing (onInput, onSubmit)
import Login.Types exposing (..)


root : Html Msg
root =
    form [ onSubmit Login ]
        [ div [ class "form-group" ]
            [ label [ for "loginUsername" ] [ text "Username" ]
            , input [ class "form-control", id "loginUsername", onInput Username ] []
            ]
        , div [ class "form-group" ]
            [ label [ for "loginPassword" ] [ text "Password" ]
            , input [ class "form-control", id "loginPassword", type_ "password", onInput Password ] []
            ]
        , button
            [ class "btn btn-primary", type_ "submit" ]
            [ text "Login" ]
        ]
