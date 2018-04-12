package wsave.logging;


class Logging {
    static var defaultLoggerSet:LoggerSet = new LoggerSet();

    public static function getLogger(namespace:String = "root"):Logger {
        return defaultLoggerSet.getLogger(namespace);
    }

    public static function addHandler(handler:Handler) {
        defaultLoggerSet.addHandler(handler);
    }

    public static function removeHandler(handler:Handler) {
        defaultLoggerSet.removeHandler(handler);
    }
}
