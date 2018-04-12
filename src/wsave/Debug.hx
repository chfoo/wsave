package wsave;

import haxe.macro.Expr;


class Debug {
    macro static public function assert(condition:Expr, ?message:Expr) {
        #if debug
        var error = 'Assertion error: ${condition.pos}: ${condition.toString()}, ';
        return macro {
            if (!($condition)) {
                throw $v{error} + $message;
            };
        }
        #else
        return macro {};
        #end
    }
}
