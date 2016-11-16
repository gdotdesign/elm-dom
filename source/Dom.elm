module Dom exposing (..)

import Task exposing (Task)
import Native.Dom


{-| All functions loop up elmements with a selector, which is just an
alias for string.
-}
type alias Selector =
  String


{-| Represents a point in the screen. Top and left are used (instead of x and y
) because they are used by CSS.
-}
type alias Position =
  { left : Int
  , top : Int
  }


{-| Represents an elements bounding box and dimensions. This structure matches
[`Element.getBoundingClientRect`](https://developer.mozilla.org/en/docs/Web/API/Element/getBoundingClientRect).
-}
type alias Dimensions =
  { height : Float
  , bottom : Float
  , width : Float
  , right : Float
  , left : Float
  , top : Float
  }


{-| These are the types of errors that can occur when using these functions.
-}
type Error
  = ElementNotFound Selector
  | InvalidSelector Selector


{-| Creates an ID (attribute) selector from the given string.

    selector = Dom.idSelector "container"
    -- [id='container']
-}
idSelector : String -> Selector
idSelector value =
  "[id='" ++ value ++ "']"



--- QUERYING ----


{-| Tests if the given position is over any element that matches the given
selector. It uses the [`document.elementFromPoint`](https://developer.mozilla.org/en-US/docs/Web/API/Document/elementFromPoint)
api, along with [`Element.matches`](https://developer.mozilla.org/en-US/docs/Web/API/Element/matches).

    isOverContainer = Dom.isOver '#container' { top = 10, left = 10 }
    -- Ok True

The JavaScript equivalent of the code above:

    var element = document.elementFromPoint(position.left, position.top)
    element.matches('#container, #container *')

*This does not force layout / reflow.*
-}
isOver : String -> Position -> Result Error Bool
isOver selector position =
  Native.Dom.isOver selector position


{-| Returns a tasks which returns true if there is a currently focued element,
false otherwise.
-}
hasFocusedElement : Task Never Bool
hasFocusedElement =
  Native.Dom.hasFocusedElement


{-| Returns true if there is a currently focued element,
false otherwise.
-}
hasFocusedElementSync : () -> Bool
hasFocusedElementSync _ =
  Native.Dom.hasFocusedElementSync



---- DIMENSIONS ----


{-| Returns a task that returns the dimensions for the element with given
selector.
-}
getDimensions : Selector -> Task Error Dimensions
getDimensions selector =
  Native.Dom.getDimensions selector


{-| Returns the dimensions for the element with given
selector.
-}
getDimensionsSync : Selector -> Result Error Dimensions
getDimensionsSync selector =
  Native.Dom.getDimensionsSync selector



{-
   ---- SCROLL ----

   scrollToX : Selector -> Task Error ()

   scrollToXSync : Selector -> Result Error ()

   getScrollX : Selector -> Task Error Int

   getScrollXSync : Selector -> Task Error Int

   getScrollY : Selector -> Task Error Int

   getScrollYSync : Selector -> Task Error Int

   scrollIntoView : Selector -> Task Error ()

   scrollIntoViewSync Selector -> Result Error ()

   scrollIntoView : Selector -> Task Error ()

   scrollIntoViewSync Selector -> Result Error ()

   scrollIntoViewIfNeeded : Selector -> Task Error ()

   scrollIntoViewIfNeededSync Selector -> Result Error ()


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
