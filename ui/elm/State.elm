module State exposing (..)

import Lobby.State
import Nav exposing (parseRoute)
import Navigation exposing (Location)
import Types exposing (..)


initialModel : Model
initialModel =
    { route = Nothing
    , lobby = Lobby.State.initialModel
    }


init : Location -> ( Model, Cmd Msg )
init location =
    let
        route =
            parseRoute location

        ( lobby, lobbyCmd ) =
            Lobby.State.init
    in
        ( { initialModel
            | route = route
            , lobby = lobby
          }
        , Cmd.map LobbyMsg lobbyCmd
        )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UrlChange location ->
            ( { model | route = parseRoute location }
            , Cmd.none
            )

        LobbyMsg lobbyMsg ->
            let
                ( lobby, lobbyCmd ) =
                    Lobby.State.update lobbyMsg model.lobby
            in
                ( { model | lobby = lobby }
                , Cmd.map LobbyMsg lobbyCmd
                )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
