import Spec exposing (describe, it, Node, before)
import Spec.Steps exposing (click, setValue)
import Spec.Assertions exposing (assert)
import Spec.Runner

import Html.Attributes exposing (defaultValue, class)
import Html exposing (input, div, button, text)
import Html.Events exposing (onClick)

import Task
import DOM

type alias Model
  = String


type Msg
  = HaveSetValue (Result DOM.Error ())
  | GotValue (Result DOM.Error String)
  | GetValueSync
  | GetValue
  | SetValueSync
  | SetValue


init : () -> Model
init _ = ""


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    SetValueSync ->
      let
        _ = DOM.setValueSync "sync" "input"
      in
        ( "", Cmd.none)

    HaveSetValue result ->
      ( "", Cmd.none )

    GotValue result ->
      case result of
        Ok value -> ( value, Cmd.none )
        Err error -> ( toString error, Cmd.none )

    GetValueSync ->
      case DOM.getValueSync "input" of
        Ok value -> ( value, Cmd.none )
        Err error -> ( toString error, Cmd.none )

    GetValue ->
      ( "", Task.attempt GotValue (DOM.getValue "input"))

    SetValue ->
      ( "", Task.attempt HaveSetValue (DOM.setValue "async" "input") )

view : Model -> Html.Html Msg
view model =
  div []
    [ input [] [ ]
    , button [ class "set-value", onClick SetValue ] []
    , button [ class "set-value-sync", onClick SetValueSync ] []
    , button [ class "get-value", onClick GetValue ] []
    , button [ class "get-value-sync", onClick GetValueSync ] []
    , div [ class "result" ] [ text model ]
    ]


specs : Node
specs =
  describe "Value"
    [ before
      [ assert.valueEquals { text = "", selector = "input" }
      , assert.containsText { text = "", selector = "div.result" }
      ]
    , describe "Set Value"
      [ it ".setValue"
        [ click "button.set-value"
        , assert.valueEquals { text = "async", selector = "input" }
        ]
      , it ".setValueSync"
        [ click "button.set-value-sync"
        , assert.valueEquals { text = "sync", selector = "input" }
        ]
      ]
    , describe "Get Value"
      [ it ".getValue"
        [ setValue { selector = "input", value = "test" }
        , click "button.get-value"
        , assert.containsText { text = "test", selector = "div.result" }
        ]
      , it ".getValueSync"
        [ setValue { selector = "input", value = "testSync" }
        , click "button.get-value-sync"
        , assert.containsText { text = "testSync", selector = "div.result" }
        ]
      ]
    ]

main =
  Spec.Runner.runWithProgram
    { subscriptions = \_ -> Sub.none
    , update = update
    , view = view
    , init = init
    } specs
