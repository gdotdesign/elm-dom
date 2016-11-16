module Dom exposing (..)

{-| This package provides tasks and synchronous functions (which returns tasks)
for querying and manipulating the DOM.

# Models
@docs Selector, Position, Dimensions

# Errors
@docs Error

# Scroll
@docs scrollToX, scrollToXSync, scrollToY, scrollToYSync

# Focus
@docs blur, blurSync, focus, focusSync, hasFocusedElement, hasFocusedElementSync

# Dimensions
@docs getDimensions, getDimensionsSync, isOver

# Selection
@docs selectAll, selectAllSync

# Miscellaneous
@docs idSelector
-}

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

  * ElementNotFound - If no element is found with the given selector
  * InvalidSelector - If the given selector is invalid
  * TextNotSelectable - If selectAll called on not an input or a textarea
-}
type Error
  = ElementNotFound Selector
  | InvalidSelector Selector
  | TextNotSelectable Selector


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



---- FOCUS / BLUR ----


{-| Returns a task that focuses the given selector.
-}
focus : Selector -> Task Error ()
focus selector =
  Native.Dom.focus selector


{-| Focuses the given selector.
-}
focusSync : Selector -> Result Error ()
focusSync selector =
  Native.Dom.focusSync selector


{-| Returns a task that blurs the given selector.
-}
blur : Selector -> Task Error ()
blur selector =
  Native.Dom.blur


{-| Blurs the given selector.
-}
blurSync : Selector -> Result Error ()
blurSync selector =
  Native.Dom.blurSync


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



---- SELECTION ----


{-| Returns a task that selects all text in the given selector.
-}
selectAll : Selector -> Task Error ()
selectAll selector =
  Native.Dom.selectAll selector


{-| Selects all text in the given selector.
-}
selectAllSync : Selector -> Result Error ()
selectAllSync selector =
  Native.Dom.selectAllSync selector



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



---- SCROLL ----


{-| Returns a task that sets the horizontal scroll position of the element with
the given selector.
-}
scrollToX : Int -> Selector -> Task Error ()
scrollToX to selector =
  Native.Dom.scrollToX to selector


{-| Sets the horizontal scroll position of the element with the given selector.
-}
scrollToXSync : Int -> Selector -> Result Error ()
scrollToXSync to selector =
  Native.Dom.scrollToXSync to selector


{-| Returns a task that sets the vertical scroll position of the element with
the given selector.
-}
scrollToY : Int -> Selector -> Task Error ()
scrollToY to selector =
  Native.Dom.scrollToY to selector


{-| Sets the vertical scroll position of the element with the given selector.
-}
scrollToYSync : Int -> Selector -> Result Error ()
scrollToYSync to selector =
  Native.Dom.scrollToYSync to selector



{-

   getScrollX : Selector -> Task Error Int

   getScrollXSync : Selector -> Task Error Int

   getScrollY : Selector -> Task Error Int

   getScrollYSync : Selector -> Task Error Int

   scrollIntoView : Selector -> Task Error ()

   scrollIntoViewSync Selector -> Result Error ()

   scrollIntoViewIfNeeded : Selector -> Task Error ()

   scrollIntoViewIfNeededSync Selector -> Result Error ()

   ---- GET / SET VALUE ----

   setValue : Selector -> String -> Task Error ()

   setValueSync : Selector -> String -> Result Error ()

   getValue : Selector -> Task Error String

   getValueSync : Selector -> Result Error String

   ---- SELECTION ----

   setSelection : Int -> Int -> String -> Task Error ()

   setSelectionSync : Int -> Int -> String -> Task Error ()
-}
