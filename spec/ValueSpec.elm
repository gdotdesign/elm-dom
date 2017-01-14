import Spec exposing (describe, it, Node)
import Spec.Assertions exposing (assert)
import Spec.Steps exposing (click)
import Spec.Runner

import Html.Attributes exposing (defaultValue)
import Html.Events exposing (onClick)
import Html exposing (input)

import Task
import DOM

type alias Model
  = String

type Msg
  = HaveSetValue (Result DOM.Error ())
  | SetValue

init : () -> Model
init _ = ""

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    HaveSetValue result ->
      ( "", Cmd.none )

    SetValue ->
      ( "", Task.attempt HaveSetValue (DOM.setValue "something" "input") )

view : Model -> Html.Html Msg
view model =
  input [ defaultValue "empty", onClick SetValue ] [ ]

specs : Node
specs =
  describe "Value"
    [ it "clicking on the input should change the text"
      [ assert.valueEquals { text = "empty", selector = "input" }
      , click "input"
      , assert.valueEquals { text = "something", selector = "input" }
      ]
    ]

main =
  Spec.Runner.runWithProgram
    { subscriptions = \_ -> Sub.none
    , update = update
    , view = view
    , init = init
    } specs
