module Login.View exposing (root)

import Html exposing (Html, button, div, p, text)
import Html.Attributes exposing (class, type_)
import Html.Events exposing (onClick)
import Login.Types exposing (..)


root : Html Msg
root =
    div []
        [ p [] [ text "Please Log In" ]
        , p []
            [ button
                [ class "btn btn-primary", type_ "submit", onClick Login ]
                [ text "Login" ]
            ]
        ]
