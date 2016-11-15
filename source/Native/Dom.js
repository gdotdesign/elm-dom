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

  var async = function(selector, method) {
    return task(function(callback){
      try {
        callback(succeed(method(selector)))
      } catch (error) {
        callback(fail(error))
      }
    })
  }

  var sync = function(selector, method) {
    try {
      return ok(method(selector))
    } catch (error) {
      return err(error)
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

  /* Get the dimensions for an element asynchronously with a task. */
  var getDimensions = function(selector){
    return async(selector, getDimensionsObject)
  }

  /* Get the dimensions for an element synchronously returning a result */
  var getDimensionsSync = function(selector){
    return sync(selector, getDimensionsObject)
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

  var hasFocusedElement = function(){
    return !!document.querySelector('*:focus')
  }

  return {
    hasFocusedElement: hasFocusedElement,
    getDimensionsSync: getDimensionsSync,
    getDimensions: getDimensions,
    isOver: F2(isOver),
    nextTick: nextTick
  }
}()
