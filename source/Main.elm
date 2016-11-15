import Html.Events exposing (..)
import Html exposing (..)

import Task

import Dom

type Msg
  = GetDimensions
  | GetDimensionsSync
  | GotDimensions (Result Dom.Error Dom.Dimensions)
  | GetDimensionsSyncFail
  | GetDimensionsFail

update msg model =
  case Debug.log "" msg of
    GetDimensionsSyncFail ->
      case Dom.getDimensionsSync "asd" of
        Ok rect -> (toString rect, Cmd.none)
        Err error -> (toString error, Cmd.none)

    GetDimensionsSync ->
      case Dom.getDimensionsSync "button" of
        Ok rect -> (toString rect, Cmd.none)
        Err error -> (toString error, Cmd.none)

    GotDimensions result ->
      case result of
        Ok rect -> (toString rect, Cmd.none)
        Err error -> (toString error, Cmd.none)

    GetDimensions ->
      ( model, Task.attempt GotDimensions (Dom.getDimensions "button") )

    GetDimensionsFail ->
      ( model, Task.attempt GotDimensions (Dom.getDimensions "1-asd") )


view model =
  div []
    [ text model
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
    { init = ("", Cmd.none)
    , view = view
    , update = update
    , subscriptions = \_ -> Sub.none
    }
