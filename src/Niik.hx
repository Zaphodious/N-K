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
        var splitted = protosplitted.map(
            function(s: String) {
                var sp = s.split("{");
                var rlst = new CSSRuleset();
                trace("sp is " + sp);
                var rawrules = sp.pop();
                var rawselectors = sp.pop();
                trace("sp now is " + sp);
                var newSelectors = rawselectors.split(",").map(function(a) return a.replace("\n", "")).map(StringTools.trim);
                newSelectors.remove("");
                var newRules = rawrules.split(";").map(function(a) return a.replace("\n", "")).map(StringTools.trim);
                newRules.remove("");
                newRules.remove("\n");

                return [newRules, newSelectors];
            }
        );
        trace(splitted);
        return cssString;
    }


    public static function startWithSRC(srcString: String) {
        window.fetch(srcString)
            .then(function(a) {return a.text();})
            .then(function(a) {startWithString(a);});
    }
}

class CSSRuleset {
    public var selectors: Array<String>;
    public var rules: Array<{rule: String, funcName: String}>;
    public function new() {};
}