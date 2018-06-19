module About.View exposing (root)

import Html exposing (Html, div, p, text)
import Types exposing (Msg)


root : Html Msg
root =
    div []
        [ p [] [ text "About" ] ]
