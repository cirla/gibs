port module Session exposing (..)


type alias Session =
    { token : String
    }


port setSession : Session -> Cmd msg


parseSession : String -> Maybe Session
parseSession data =
    Just { token = data }
