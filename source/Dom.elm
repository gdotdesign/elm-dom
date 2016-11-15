module Dom exposing (..)

import Task exposing (Task)
import Native.Dom

type alias Selector =
  String

type alias Position =
  { left : Int
  , top : Int
  }

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

idSelector : String -> Selector
idSelector value =
  "[id='" ++ value ++ "']"

--- QUERYING ----

isOver : String -> Position -> Result Error Bool
isOver selector position =
  Native.Dom.isOver selector position

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

decodeScrollPosition : Selector -> Json.Decoder Position

scrollToX : Selector -> Task Error ()

scrollToXSync : Selector -> Result Error ()

getScrollX : Selector -> Task Error Int

getScrollXSync : Selector -> Task Error Int

getScrollY : Selector -> Task Error Int

getScrollYSync : Selector -> Task Error Int


---- FOCUS / BLUR ----

focus : Selector -> Task Error ()

focusSync : Selector -> Result Error ()

blur : Selector -> Task Error ()

blurSync : Selector -> Result Error ()

---- GET / SET VALUE ----

setValue : Selector -> String -> Task Error ()

setValueSync : Selector -> String -> Result Error ()

getValue : Selector -> Task Error String

getValueSync : Selector -> Result Error String

---- SELECTION ----

selectAll : Selector -> Task Error ()

selectAllSync : Selector -> Result Error ()
-}
