package wsave.test.logging;

import utest.Assert;
import wsave.logging.ConsoleHandler;
import wsave.logging.Level;
import wsave.logging.LoggerSet;


class TestLogging {
    public function new() {
    }

    public function testConsoleHandler() {
        var loggerSet = new LoggerSet();
        var handler = new ConsoleHandler();
        loggerSet.addHandler(handler);
        var logger = loggerSet.getLogger();

        logger.debug("test", [ "key" => "Hello world!" ]);

        Assert.stringContains("test", handler.currentLine);

        logger.critical("test");
        logger.error("test");
        logger.warning("test");
        logger.info("test");
        logger.debug("test");
        logger.verbose("test");

        try {
            throw "test";
        } catch (exception:Dynamic) {
            logger.exception(Level.Debug, "test", exception);
        }
    }
}
