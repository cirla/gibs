module Lobby.View exposing (root)

import Html exposing (Html, div, p, text)
import Lobby.Types exposing (..)


root : Model -> Html Msg
root model =
    div []
        [ p []
            [ text
                ("Welcome, "
                    ++ case model.session of
                        Just session ->
                            session.token

                        Nothing ->
                            "Guest"
                )
            ]
        ]
