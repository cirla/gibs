module Main exposing (main)

import Navigation exposing (program)
import State exposing (init, update, subscriptions)
import Types exposing (..)
import View exposing (root)


main : Program Never Model Msg
main =
    program UrlChange
        { init = init
        , view = root
        , update = update
        , subscriptions = subscriptions
        }
