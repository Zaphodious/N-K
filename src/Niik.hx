package ;

import js.Browser;
import js.Browser.document;
import js.Browser.window;
import js.html.Event;
import js.html.Response;
import js.Promise;
import js.Lib;
import String;
import StringTools;

using String;
using StringTools;

@:expose
class Niik {

    public static function startWithString(cssString: String) {
        var protosplitted = cssString.split("}");
        protosplitted.remove("");
        var parsedRules: Array<CSSRuleset> = protosplitted.map(
            function(s: String) {
                var sp = s.split("{");
                var rawrules = sp.pop();
                var rawselectors = sp.pop();
                var newSelectors = rawselectors.split(",").map(function(a) return a.replace("\n", "")).map(StringTools.trim);
                newSelectors.remove("");
                var newRules = rawrules.split(";").map(function(a) return a.replace("\n", "")).map(StringTools.trim);
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
        trace(parsedRules);
        return cssString;
    }


    public static function startWithSRC(srcString: String) {
        window.fetch(srcString)
            .then(function(a) {return a.text();})
            .then(function(a) {startWithString(a);});
    }
}

typedef CSSRule = {eventname: String, funcname: String};
typedef CSSRuleset = {selectors: Array<String>, rules: Array<CSSRule>};