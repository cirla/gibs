module Main exposing (..)

import Html exposing (Html, a, button, div, i, li, nav, p, span, text, ul)
import Html.Attributes exposing (attribute, class, id, href, type_)
import Html.Attributes.Aria exposing (role)
import Navigation
import UrlParser as Url exposing (Parser, (</>), oneOf, s, top)


-- PROGRAM


main : Program Never Model Msg
main =
    Navigation.program UrlChange
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- NAVIGATION


type Route
    = Home
    | About


toHash : Route -> String
toHash route =
    case route of
        Home ->
            "#"

        About ->
            "#about"


route : Url.Parser (Route -> a) a
route =
    Url.oneOf
        [ Url.map Home top
        , Url.map About (s "about")
        ]


parseRoute : Navigation.Location -> Maybe Route
parseRoute =
    Url.parseHash route



-- MODEL


type alias Model =
    { route : Maybe Route
    }


initialModel : Model
initialModel =
    { route = Nothing
    }


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    ( { initialModel | route = parseRoute location }
    , Cmd.none
    )



-- UPDATE


type Msg
    = UrlChange Navigation.Location


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UrlChange location ->
            ( { model | route = parseRoute location }
            , Cmd.none
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
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
                [ navLink Home "Home" (model.route == Just Home)
                , navLink About "About" (model.route == Just About)
                ]
            ]
        ]


navLink : Route -> String -> Bool -> Html msg
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
        [ a [ class "nav-link", href (toHash route) ] [ text title ]
        ]


viewRoute : Model -> Html Msg
viewRoute model =
    case model.route of
        Just About ->
            viewAbout model

        _ ->
            viewHome model


viewHome : Model -> Html Msg
viewHome model =
    div []
        [ p [] [ text "Home" ] ]


viewError : String -> a -> Html msg
viewError msg e =
    let
        _ =
            Debug.log "Error" <| toString e
    in
        div [ class "alert alert-danger", role "alert" ] [ text msg ]


viewAbout : Model -> Html Msg
viewAbout model =
    div []
        [ p [] [ text "About" ] ]
