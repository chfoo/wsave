package wsaveapp;

import tink.Cli;


class ArgParserTools {
    public static function showHelp<T>(command:T) {
        // TODO: this doesn't work
        var doc = Cli.getDoc(command);
        Sys.stderr().writeString(doc);
    }

    public static function exitParserError(errorMessage:String) {
        Sys.stderr().writeString(errorMessage);
        Sys.exit(2);
    }
}
