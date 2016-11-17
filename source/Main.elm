import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html exposing (..)

import Json.Decode as Json

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
  | Select
  | SelectDone (Result Dom.Error ())
  | SelectSync
  | Move Mouse.Position
  | ScrollToXSync
  | ScrollToYSync
  | ScrollIntoViewSync
  | Scrolled

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

    SelectDone result ->
      case result of
        Ok _ -> (model, Cmd.none)
        Err error -> ({ model | error = error }, Cmd.none)

    Select ->
      ( model, Task.attempt SelectDone (Dom.select "#input2"))

    SelectSync ->
      case Dom.selectSync "#input1" of
        _ -> ( model, Cmd.none )

    ScrollToXSync ->
      case Dom.setScrollLeftSync 50 "#scrollContainer" of
        Ok _ -> (model, Cmd.none)
        Err error -> ({ model | error = error }, Cmd.none)

    ScrollToYSync ->
      case Dom.setScrollTopSync 50 "#scrollContainer" of
        Ok _ -> (model, Cmd.none)
        Err error -> ({ model | error = error }, Cmd.none)

    ScrollIntoViewSync ->
      case Dom.scrollIntoViewSync "#viewElement" of
        Ok _ -> (model, Cmd.none)
        Err error -> ({ model | error = error }, Cmd.none)

    Scrolled ->
      let
        _ = Debug.log "Scroll left" (Dom.getScrollLeftSync "#scrollContainer")
        _ = Debug.log "Scroll top" (Dom.getScrollTopSync "#scrollContainer")
      in
        ( model, Cmd.none )

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
      [ button [ onClick SelectSync ] [ text "Select All Sync" ]
      , button [ onClick Select ] [ text "Select All" ]
      ]

    , div
      [ style
        [("width", "300px")
        ,("height", "300px")
        ,("overflow", "scroll")
        ]
      , on "scroll" (Json.succeed Scrolled)
      , id "scrollContainer"
      ]
      [ div
        [ style
          [("width", "500px")
          ,("height", "500px")
          ,("position", "relative")
          ]
        ]
        [ div
          [ style
            [("width", "50px")
            ,("height", "50px")
            ,("background", "red")
            ,("position", "absolute")
            ,("bottom", "0")
            ,("right", "0")
            ]
          , id "viewElement"
          ] []
        ]
      ]

    , div []
      [ button [ onClick ScrollToXSync ] [ text "ScrollToX Sync" ]
      , button [ onClick ScrollToYSync ] [ text "ScrollToY Sync" ]
      , button [ onClick ScrollIntoViewSync ] [ text "ScrollIntoViewSync Sync" ]
      ]
    ]

main =
  Html.program
    { init = (init, Cmd.none)
    , view = view
    , update = update
    , subscriptions = \_ -> Mouse.moves Move
    }
