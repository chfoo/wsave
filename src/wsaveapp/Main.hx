package wsaveapp;

import tink.Cli;
import wsave.logging.Logging;
import wsave.logging.ConsoleHandler;


class Main {
    public static function main() {
        Logging.addHandler(new ConsoleHandler());

        Cli.process(Sys.args(), new Options()).handle(Cli.exit);
    }
}
