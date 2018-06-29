module Login.View exposing (root)

import Html exposing (Html, button, div, form, i, input, label, p, text)
import Html.Attributes exposing (class, for, id, type_)
import Html.Attributes.Aria exposing (role)
import Html.Events exposing (onInput, onSubmit)
import Http exposing (Error(..))
import Login.Types exposing (..)


root : Model -> Html Msg
root model =
    let
        errorDiv =
            Maybe.map (error >> List.singleton) model.error
                |> Maybe.withDefault []
    in
        div [] (errorDiv ++ [ loginForm ])


error : Error -> Html Msg
error e =
    div [ class "alert alert-danger", role "alert" ]
        [ i [ class "fas fa-exclamation-circle" ] []
        , case e of
            BadStatus resp ->
                text resp.body

            _ ->
                text "An error has occurred."
        ]


loginForm : Html Msg
loginForm =
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
