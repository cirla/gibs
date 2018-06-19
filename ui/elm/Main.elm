module Main exposing (main)

import Navigation exposing (programWithFlags)
import State exposing (init, update, subscriptions)
import Types exposing (..)
import View exposing (root)


main : Program Flags Model Msg
main =
    programWithFlags UrlChange
        { init = init
        , view = root
        , update = update
        , subscriptions = subscriptions
        }
