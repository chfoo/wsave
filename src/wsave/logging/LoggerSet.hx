package wsave.logging;

class LoggerSet {
    var loggers:Map<String,Logger>;
    var handlers:Array<Handler>;

    public function new() {
        loggers = new Map();
        handlers = [];
    }

    public function getLogger(namespace:String = "root"):Logger {
        if (!loggers.exists(namespace)) {
            loggers.set(namespace, new Logger(namespace, handlers));
        }

        return loggers.get(namespace);
    }

    public function addHandler(handler:Handler) {
        if (handlers.indexOf(handler) < 0) {
            handlers.push(handler);

            for (logger in loggers) {
                logger.addHandler(handler);
            }
        }
    }

    public function removeHandler(handler:Handler) {
        handlers.remove(handler);
        for (logger in loggers) {
            logger.removeHandler(handler);
        }
    }
}
