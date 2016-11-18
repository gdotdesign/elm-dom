module DOM.Window exposing (..)

{-| This module contains functions for getting the dimensions and scroll
position of the `window` JavaScript object.
-}

import Native.DOM


{-| Returns the vertical scroll position of the window.
-}
scrollTop : () -> Int
scrollTop _ =
  Native.DOM.windowScrollTop ()


{-| Returns the horizontal scroll position of the window.
-}
scrollLeft : () -> Int
scrollLeft _ =
  Native.DOM.windowScrollLeft ()


{-| Returns the width of the window.
-}
width : () -> Int
width _ =
  Native.DOM.windowWidth ()


{-| Returns the height of the window.
-}
height : () -> Int
height _ =
  Native.DOM.windowHeight ()
