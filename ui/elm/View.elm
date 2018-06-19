module View exposing (root)

import About.View
import Html exposing (Html, a, button, div, i, li, nav, p, span, text, ul)
import Html.Attributes exposing (attribute, class, id, href, type_)
import Lobby.View
import Nav
import Types exposing (..)


root : Model -> Html Msg
root model =
    div []
        [ viewNav model
        , div [ class "container" ] [ viewRoute model ]
        ]


viewNav : Model -> Html Msg
viewNav model =
    nav [ class "navbar fixed-top navbar-expand-md navbar-dark bg-dark" ]
        [ a [ class "navbar-brand", href "#" ] [ text "GIBS" ]
        , button
            [ class "navbar-toggler"
            , type_ "button"
            , attribute "data-toggle" "collapse"
            , attribute "data-target" "#navbarSupportedContent"
            ]
            [ span [ class "navbar-toggler-icon" ] [] ]
        , div [ class "collapse navbar-collapse", id "navbarSupportedContent" ]
            [ ul [ class "navbar-nav mr-auto" ]
                [ navLink Nav.Lobby "Home" (model.route == Just Nav.Lobby)
                , navLink Nav.About "About" (model.route == Just Nav.About)
                ]
            ]
        ]


navLink : Nav.Route -> String -> Bool -> Html msg
navLink route title active =
    li
        [ "nav-item"
            ++ (if active then
                    " active"
                else
                    ""
               )
            |> class
        ]
        [ a [ class "nav-link", href (Nav.toHash route) ] [ text title ]
        ]


viewRoute : Model -> Html Msg
viewRoute model =
    case model.route of
        Just Nav.About ->
            About.View.root

        _ ->
            Html.map LobbyMsg (Lobby.View.root model.lobby)
