module Dom exposing (..)

import Task exposing (Task)
import Native.Dom

type alias Selector = String

type alias Dimensions =
  { height : Float
  , bottom : Float
  , width : Float
  , right : Float
  , left : Float
  , top : Float
  }

type Error
  = ElementNotFound Selector
  | InvalidSelector Selector

id : String -> Selector
id value =
  "[id='" ++ value ++ "']"

--- QUERYING ----

isOver : String -> Int -> Int -> Result Error Bool
isOver selector x y =
  Native.Dom.isOver selector x y

hasFocusedElement : Task Never Bool
hasFocusedElement =
  Native.Dom.hasFocusedElement

hasFocusedElementSync : () -> Bool
hasFocusedElementSync _ =
  Native.Dom.hasFocusedElementSync

---- DIMENSIONS ----

{-| Gets the dimensions for the element with given selector using a Task.
-}
getDimensions : Selector -> Task Error Dimensions
getDimensions selector =
  Native.Dom.getDimensions selector

{-| Gets the dimensions for the element with given selector synchronously
resulting in a resource.
-}
getDimensionsSync : Selector -> Result Error Dimensions
getDimensionsSync selector =
  Native.Dom.getDimensionsSync selector

{- Decode dimensions from an element using a Json.Decoder.
- }
decodeDimensions : Json.Decoder Dimension


---- SCROLL ----

scrollToX : Selector -> Task Error ()

scrollToXSync : Selector -> Result Error ()

getScrollX : Selector -> Task Error ()

getScrollXSync : Selector -> Task Error ()

getScrollY : Selector -> Task Error ()

getScrollYSync : Selector -> Task Error ()


---- FOCUS / BLUR ----

focus : Selector -> Task Error ()

focusSync : Selector -> Result Error ()

blur : Selector -> Task Error ()

blurSync : Selector -> Result Error ()
-}
