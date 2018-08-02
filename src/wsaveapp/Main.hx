package wsaveapp;

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
        switch (result) {
            case Success(_):
                // empty
            case Failure(error):
                var message = "Error parsing arguments.";

                // Nice error message :P
                // TODO: better help
                if (error.message != "Unexpected Error") {
                    message += error.message;
                }

                ArgParserTools.exitParserError(message);
        }
    }
}
