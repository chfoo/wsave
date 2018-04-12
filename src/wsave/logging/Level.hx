package wsave.logging;


abstract Level(Int) to Int from Int {
    public static inline var Verbose = 20;
    public static inline var Debug = 40;
    public static inline var Info = 60;
    public static inline var Warning = 80;
    public static inline var Error = 100;
    public static inline var Critical = 110;

    @:op(A > B) static function gt(a:Level, b:Level):Bool;
    @:op(A < B) static function lt(a:Level, b:Level):Bool;

    public function toString():String {
        switch (this) {
            case Level.Verbose:
                return "verbose";
            case Level.Debug:
                return "debug";
            case Level.Info:
                return "info";
            case Level.Warning:
                return "warning";
            case Level.Error:
                return "error";
            case Level.Critical:
                return "critical";
            default:
                return 'level($this)';
        }
    }
}
