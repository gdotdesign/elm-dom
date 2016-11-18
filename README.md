# elm-dom
Alternative package for DOM manipulation.

## Why? What's wrong with Elms DOM package?
The official DOM package have a different mindset and some missing features (check the comparison below).

This package aims to have a similar API that JavaScript developers are used to, but in a more structured way. 

These APIs include:

- [x] [document.elementFromPoint()]() to test if an element is over a point (usually the cursor)
- [x] [Element.getBoundingClientRect()]() to get dimensions
- [x] [Element.select()]() to select text in inputs and textareas
- [x] [Element.focus()]() to focus elements
- [x] [Element.blur()]() to blur elements

Without some of these APIs is really difficult to create some UI interactions (dropdowns, drag & drop, etc..), and developers 
are forced to use unusal methods to replace these (maily abusing decoders as seen in [debois/elm-dom]()) which is not ideal.

## Synchronous and Asynchronous functions
This package provides synchronous and asynchronous versions of the APIs to provide even more flexibility:

Asynchronous functions are the default and they give back a `Task` to execute:
```elm
DOM.getDimensions "some selector"
-- Task DOM.Error DOM.Dimensions
```

Synchronous functions are executed at runtime and give back a `Result`
```elm
DOM.getDimensions "some selector"
-- Result DOM.Error DOM.Dimensions
```

## Missing APIs
If you miss some of the APIs just open an issue or leave a comment on [this issue](https://github.com/gdotdesign/elm-dom/issues/1).

## DOM Packages Comparison
Here you can find the features of each DOM related package.

Feature	| gdotdesign/elm-dom | elm-lang/dom |	debois/elm-dom 
--------|--------------------|--------------|---------------
focus	  | x                  | x	          |
blur    | x                  | x            |
set horizontal scroll position|	x	| x	 |
get horizontal scroll position|	x	| x |	x
set vertical scroll position|	x	| x |	
get vertical scroll position|	x	| x |	x
scroll an element into the viewport|	x	| 	
get dimensions of an element | x	| | x
set value of an element	| x		
get value of an element	| x		
select all text in an input / textarea | x			
test if an element is over the given position	| x		
test if is there any focused element | x		
