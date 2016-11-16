import Html.Attributes exposing (..)
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
  | Focus
  | Focused (Result Dom.Error ())
  | FocusSync
  | SelectAll
  | SelectAllDone (Result Dom.Error ())
  | SelectAllSync
  | Move Mouse.Position
  | ScrollToXSync
  | ScrollToYSync

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

    FocusSync ->
      case Dom.focusSync "#input1" of
        _ -> ( model, Cmd.none )

    Focus ->
      ( model, Task.attempt Focused (Dom.focus "#input2") )

    Focused result ->
      case result of
        Ok _ -> (model, Cmd.none)
        Err error -> ({ model | error = error }, Cmd.none)

    SelectAllDone result ->
      case result of
        Ok _ -> (model, Cmd.none)
        Err error -> ({ model | error = error }, Cmd.none)

    SelectAll ->
      ( model, Task.attempt SelectAllDone (Dom.selectAll "#input2"))

    SelectAllSync ->
      case Dom.selectAllSync "#input1" of
        _ -> ( model, Cmd.none )

    ScrollToXSync ->
      case Dom.scrollToXSync 50 "#scrollContainer" of
        Ok _ -> (model, Cmd.none)
        Err error -> ({ model | error = error }, Cmd.none)

    ScrollToYSync ->
      case Dom.scrollToYSync 50 "#scrollContainer" of
        Ok _ -> (model, Cmd.none)
        Err error -> ({ model | error = error }, Cmd.none)

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

    , input [ id "input1" ] []
    , input [ id "input2" ] []

    , div []
      [ button [ onClick FocusSync ] [ text "Focus Sync" ]
      , button [ onClick Focus ] [ text "Focus" ]
      ]

    , div []
      [ button [ onClick SelectAllSync ] [ text "Select All Sync" ]
      , button [ onClick SelectAll ] [ text "Select All" ]
      ]

    , div
      [ style
        [("width", "300px")
        ,("height", "300px")
        ,("overflow", "scroll")
        ]
      , id "scrollContainer"
      ]
      [ div
        [ style
          [("width", "500px")
          ,("height", "500px")
          ]
        ] []
      ]

    , div []
      [ button [ onClick ScrollToXSync ] [ text "ScrollToX Sync" ]
      , button [ onClick ScrollToYSync ] [ text "ScrollToY Sync" ]
      ]
    ]

main =
  Html.program
    { init = (init, Cmd.none)
    , view = view
    , update = update
    , subscriptions = \_ -> Mouse.moves Move
    }
