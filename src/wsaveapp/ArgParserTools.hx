package wsaveapp;

import haxe.macro.Expr;


class ArgParserTools {
    public static macro function showHelp(command:Expr):Expr {
        return macro {
            var doc = tink.Cli.getDoc($command);
            Sys.stderr().writeString(doc);
        };
    }

    public static function exitParserError(errorMessage:String) {
        Sys.stderr().writeString(errorMessage);
        Sys.stderr().writeString("\n");
        Sys.stderr().writeString("Try the \"--help\" switch for more information.\n");
        Sys.exit(2);
    }
}
