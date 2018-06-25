package ;

import js.Browser;
import js.Browser.document;
import js.Browser.window;
import js.html.Event;
import js.html.Element;
import js.html.Response;
import js.Promise;
import js.Lib;
import String;
import StringTools;

using String;
using StringTools;

@:expose("Niik")
class Niik {

    public var handlerRegistry: HandlerRegistry 
        = ["niikSample" => Niik.foo];
    
    public var rulesets: Array<CSSRuleset> = [];

    private function new() {}

    public function startWithString(cssString: String) : Niik {
        setCSSRules(cssString);
        addHandlersToChildren(document.querySelector("body"));
        return this;
    }

    public static function foo(event: Event) {
        trace("foo you too!");
    }


    public function startWithSRC(srcString: String) : Promise<Niik> {
        return window.fetch(srcString)
            .then(function(a) {return a.text();})
            .then(function(a) {return startWithString(a);});
    }

    public function registerHandler(name: String, fun: Event -> Void) : Niik {
        handlerRegistry[name] = fun;
        return this;
    }

    public function registerHandlers(newHandlers: HandlerRegistry): Niik {
        for (handlerkey in newHandlers.keys()) {
            handlerRegistry[handlerkey] = newHandlers[handlerkey];
        }
        return this;
    }

    public function addHandlersToElement(element: Element): Niik {
        for (ruleset in rulesets) {
            for (selector in ruleset.selectors) {
                if (element.matches(selector)) {
                    for (rule in ruleset.rules) {
                        element.addEventListener(rule.eventname, handlerRegistry[rule.funcname]);
                    }
                }
            }
        }
        return this;
    }

    public function removeHandlersFromElement(element: Element): Niik {
        for (ruleset in rulesets) {
            for (selector in ruleset.selectors) {
                for (rule in ruleset.rules) {
                    element.removeEventListener(rule.eventname, handlerRegistry[rule.funcname]);
                }
            }
        }
        return this;
    }

    private function addHandlersToChildren(parent: Element) {
        for (ruleset in rulesets) {
            trace(ruleset);
            for (selector in ruleset.selectors) {
                for (element in parent.querySelectorAll(selector)) {
                    for (rule in ruleset.rules) {
                            element.addEventListener(rule.eventname, handlerRegistry[rule.funcname]);
                        trace(handlerRegistry[rule.funcname]);
                        trace(rule);
                    }
                }
            }
        }
    }

    public function setCSSRules(cssString: String) {
        rulesets = Niik.parseCSS(cssString);
    }

    private static function parseCSS(cssString: String) {

        var protosplitted = cssString.split("}");
        protosplitted.remove("");
        var parsedRules: Array<CSSRuleset> = protosplitted.map(
            function(s: String) {
                var sp = s.split("{");
                var rawrules = sp.pop();
                var rawselectors = sp.pop();
                var newSelectors = rawselectors.split(",").map(function(a) return a.replace("\n", "")).map(StringTools.trim);
                newSelectors.remove("");
                var newRules = rawrules.split(";").map(function(a) 
                return a.replace("\n", "").replace("\"", "")).map(StringTools.trim);
                newRules.remove("");
                newRules.remove("\n");

                var newerRules = newRules.map(
                    function(s) {
                        var a = s.replace(" ", "").split(":");
                        return {funcname: a.pop(), eventname: a.pop()};
                    }
                );
                return {
                    selectors: newSelectors,
                    rules: newerRules,
                    };
            }
        );
        return parsedRules;
    }
}

typedef HandlerRegistry = Map<String, Event -> Void>;
typedef CSSRule = {eventname: String, funcname: String};
typedef CSSRuleset = {selectors: Array<String>, rules: Array<CSSRule>};
/* 
class Processor {
    public static function parseCSS(cssString: String) {

        var protosplitted = cssString.split("}");
        protosplitted.remove("");
        var parsedRules: Array<CSSRuleset> = protosplitted.map(
            function(s: String) {
                var sp = s.split("{");
                var rawrules = sp.pop();
                var rawselectors = sp.pop();
                var newSelectors = rawselectors.split(",").map(function(a) return a.replace("\n", "")).map(StringTools.trim);
                newSelectors.remove("");
                var newRules = rawrules.split(";").map(function(a) 
                return a.replace("\n", "").replace("\"", "")).map(StringTools.trim);
                newRules.remove("");
                newRules.remove("\n");

                var newerRules = newRules.map(
                    function(s) {
                        var a = s.replace(" ", "").split(":");
                        return {funcname: a.pop(), eventname: a.pop()};
                    }
                );
                return {
                    selectors: newSelectors,
                    rules: newerRules,
                    };
            }
        );
        return parsedRules;
    }

    public static function bindRulesToDOM(rulesets: Array<CSSRuleset>) {
        for (ruleset in rulesets) {
            trace(ruleset);
            for (selector in ruleset.selectors) {
                for (element in document.querySelectorAll(selector)) {
                    for (rule in ruleset.rules) {
                            element.addEventListener(rule.eventname, untyped __js__("window[{0}]", rule.funcname));
                        trace(untyped __js__("window[{0}]", rule.funcname));
                        trace(rule);
                    }
                }
            }
        }
    }
} */