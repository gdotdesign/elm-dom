import Html.Events exposing (..)
import Html exposing (..)

import Mouse
import Task

import Dom

type alias Model =
  { overButton : Bool
  , error : Dom.Error
  , rect : Dom.Dimensions
  }

type Msg
  = GetDimensions
  | GetDimensionsSync
  | GotDimensions (Result Dom.Error Dom.Dimensions)
  | GetDimensionsSyncFail
  | GetDimensionsFail
  | Move Mouse.Position

init =
  { overButton = False
  , error = Dom.ElementNotFound ""
  , rect = { top = 0, left = 0, right = 0, bottom = 0, width = 0, height = 0 }
  }

update msg model =
  case msg of
    GetDimensionsSyncFail ->
      case Dom.getDimensionsSync "asd" of
        Ok rect -> ({ model | rect = rect }, Cmd.none)
        Err error -> ({ model | error = error }, Cmd.none)

    GetDimensionsSync ->
      case Dom.getDimensionsSync "button" of
        Ok rect -> ({ model | rect = rect }, Cmd.none)
        Err error -> ({ model | error = error }, Cmd.none)

    GotDimensions result ->
      case result of
        Ok rect -> ({ model | rect = rect }, Cmd.none)
        Err error -> ({ model | error = error }, Cmd.none)

    GetDimensions ->
      ( model, Task.attempt GotDimensions (Dom.getDimensions "button") )

    GetDimensionsFail ->
      ( model, Task.attempt GotDimensions (Dom.getDimensions "1-asd") )

    Move position ->
      case Dom.isOver "button" { top = position.y, left = position.x } of
        Ok isOver -> ({ model | overButton = isOver }, Cmd.none)
        Err error -> ({ model | error = error }, Cmd.none)


view model =
  div []
    [ text (toString model)
    , div []
      [ button [ onClick GetDimensionsSync ] [ text "Get Dimensions Sync" ]
      , button [ onClick GetDimensions ] [ text "Get Dimensions" ]
      ]
    , div []
      [ button [ onClick GetDimensionsSyncFail ] [ text "Get Dimensions Sync Fail" ]
      , button [ onClick GetDimensionsFail ] [ text "Get Dimensions Fail" ]
      ]
    ]

main =
  Html.program
    { init = (init, Cmd.none)
    , view = view
    , update = update
    , subscriptions = \_ -> Mouse.moves Move
    }
