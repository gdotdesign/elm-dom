var _gdotdesign$elm_dom$Native_Dom = function() {
  var task = _elm_lang$core$Native_Scheduler.nativeBinding
  var succeed = _elm_lang$core$Native_Scheduler.succeed
  var fail = _elm_lang$core$Native_Scheduler.fail
  var tuple0 = _elm_lang$core$Native_Utils.Tuple0

  var err = _elm_lang$core$Result$Err
  var ok = _elm_lang$core$Result$Ok

  var withElement = function(selector, method) {
    try {
      var element = document.querySelector(selector)
    } catch (error) {
      throw { ctor: "InvalidSelector", _0: selector }
    }
    if (!element) { throw { ctor: "ElementNotFound", _0: selector } }
    return method(element)
  }

  /* Get the dimensions object for an element using getBoundingClientRect. */
  var getDimensionsObject = function(selector){
    return withElement(selector, function(element){
      var rect = element.getBoundingClientRect()

      return {
        bottom: rect.bottom,
        height: rect.height,
        width: rect.width,
        right: rect.right,
        left: rect.left,
        top: rect.top
      }
    })
  }

  var async = function(method) {
    return function(){
      var args = Array.prototype.slice.call(arguments)

      return task(function(callback){
        try {
          callback(succeed(method.apply({}, args)))
        } catch (error) {
          callback(fail(error))
        }
      })
    }
  }

  var sync = function(method) {
    return function() {
      var args = Array.prototype.slice.call(arguments)

      try {
        return ok(method.apply({}, args))
      } catch (error) {
        return err(error)
      }
    }
  }

  /* ---------------------------------------------------------------------- */

  /* Runs the given message on the next animation frame. */
  var nextTick = function(){
    return task(function(callback){
      requestAnimationFrame(function(){
        callback(succeed(tuple0))
      })
    })
  }

  /* Tests if the given coordinates are over the given selector */
  var isOver = function(selector, position){
    var element = document.elementFromPoint(position.left, position.top)
    if (!element) { err({ ctor: "ElementNotFound", _0: selector }) }
    try {
      return ok(element.matches(selector + "," + selector + " *"))
    } catch (error) {
      return err({ ctor: "InvalidSelector", _0: selector })
    }
  }

  var hasFocusedElement = function(){
    return task(function(callback){
      callback(!!document.querySelector('*:focus'))
    })
  }

  var hasFocusedElementSync = function(){
    return !!document.querySelector('*:focus')
  }

  var focus = function(selector){
    withElement(selector, function(element){
      element.focus()
      return tuple0
    })
  }

  var blur = function(selector){
    withElement(selector, function(element){
      element.blur()
      return tuple0
    })
  }

  var selectAll = function(selector) {
    withElement(selector, function(element){
      if(!element.setSelectionRange){
        throw { ctor: "TextNotSelectable", _0: selector }
      }
      element.setSelectionRange(0, element.value.length)
      return tuple0
    })
  }

  var scrollToX = function(position, selector){
    withElement(selector, function(element){
      element.scrollLeft = position
      return tuple0
    })
  }

  var scrollToY = function(position, selector){
    withElement(selector, function(element){
      element.scrollTop = position
      return tuple0
    })
  }

  return {
    hasFocusedElementSync: hasFocusedElementSync,
    hasFocusedElement: hasFocusedElement,

    getDimensionsSync: sync(getDimensionsObject),
    getDimensions: async(getDimensionsObject),

    scrollToXSync: F2(sync(scrollToX)),
    scrollToX: F2(async(scrollToX)),

    scrollToYSync: F2(sync(scrollToY)),
    scrollToY: F2(async(scrollToY)),

    selectAllSync : sync(selectAll),
    selectAll : async(selectAll),

    focusSync: sync(focus),
    focus: async(focus),

    blurSync: sync(blur),
    blur: async(blur),

    isOver: F2(isOver),
    nextTick: nextTick
  }
}()
