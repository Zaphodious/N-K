# N||k

A Haxe/JS library for using css to define event listener bindings.

[Live demo of the library in action](https://zaphodious.github.io/NiiK/index.html)

## But... why?

If you want to add event handling to a DOM element that you don't already have a reference to, the HTML5 API for doing so is ``` document.querySelector("selector").addEventListener("eventtype", callbackFunction) ```. Its a nice API! This library just abstracts over it, allowing you to use CSS to define which selectors map to which events and callbacks, and then to use those definitions to add that functionality to your nodes.

### But who is it *for*?

This is a convenience library to help framework-free Haxe (and Vanilla JS) apps keep HTML docs free of onClick declarations and functions free of verbose querySelector/addEventListener-ing. Not that there's anything wrong with that, the library author just doesn't like it too terribly much. He feels that its too easy to make mistakes, you see.

### Oh my, the built .js file is 15kb! What gives?

Admittedly, this lib is being written for use in the author's Haxe projects, so a lot of that 15kb would be there for him anyway. For folks using this from JS, the file is about 3kb when gzipped, which should be fine. The output from the Haxe to JS compiler is pretty self-contained, so bundling it up shouldn't be a problem.

### Why CSS, and not JSON or XML?

 A few reasons: CSS is the format that gave us these selectors, its designed around defining these types of mappings, its easy to parse, your editor (yes, that one) supports it already, and preprossors like SASS allow you to write nested declarations and then compile them into neat CSS files (without this lib having to implement nested declaration logic).


### What about performance?

Undetermined at this point. If its too slow, please submit an issue on this here Github project page. Or get someone to write this project in pure JS. Who knows, it might turn out better 🙂

## Basic Use

### Haxe/JS
Make a new Niik object, add callbacks to it using ``` .registerHandler(namestring, callback) ```, set the rules being used with ```setCSSRules(cssString)```, bind event handlers to a group of nodes with ```addHandlersToChildren(parent)```, to an individual element with ```addHandlersToElement(element)```, and remove handlers from an individual element with ```removeHandlersFromElement(element)```. 

For a simple start, add callbacks with addHandler and then initialize with ``` .startWithString(cssString) ``` (which executes synchroniously and returns the niik object), or ``` .startWithSRC(srcString) ``` (which gets a cssString from a css file located by srcString, and returns a Promise<Niik>) can be used to. Note that the two "startWith" methods have undefined behavior if called more then once in the same document.

### CSS

Valid selectors are any accepted by [querySelector](https://developer.mozilla.org/en-US/docs/Web/API/Element/querySelector). Valid properties are [any event types](https://developer.mozilla.org/en-US/docs/Web/Events) accepted by [addEventListener](https://developer.mozilla.org/en-US/docs/Web/API/EventTarget/addEventListener). Valid values are string keys provided to registerHandler before calling one of the addHandler or startWith methods. Ex: ``` #someid button, .allof-these button {click: doAwesomeCallback} ```

#### A note about the "Cascading" bit

Unlike CSS used for styling, properties can have multiple values, and declarations under one selector don't override declarations from another. That is, ```.a button {click:foo;} #b .a button {click:bar;}``` will result in invocations of both foo and bar when the button is clicked.