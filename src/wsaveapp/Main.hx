package wsaveapp;

import haxe.CallStack;
import callnest.TaskDefaults;
import plumekit.Exception;
import tink.core.Noise;
import tink.core.Outcome;
import tink.core.Error;
import tink.Cli;
import wsave.logging.Logging;
import wsave.logging.ConsoleHandler;


class Main {
    public static function main() {
        #if debug
        Exception.fullStackString = true;
        #end

        Logging.addHandler(new ConsoleHandler());

        Cli.process(Sys.args(), new Options()).handle(optionHandler);
    }

    static function optionHandler(result:Outcome<Noise, Error>) {
        // Don't exit because the commands are asynchronous.
        // Can't make use of Error to show help because it uses macros
        // and can't pass an instance.
        switch (result) {
            case Success(_):
                // empty
            case Failure(error):
                ArgParserTools.exitParserError(error.message);
        }
    }
}
