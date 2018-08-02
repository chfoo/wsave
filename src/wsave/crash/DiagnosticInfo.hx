package wsave.crash;


import haxe.CallStack;


class DiagnosticInfo {
    public var exception:Any;
    public var callStack:Array<StackItem>;
    public var programName:String;
    public var programArgs:Array<String>;
    public var version:String;
    public var platform:String;
    public var buildDate:String;
    public var buildHash:String;
    public var currentTimestamp:Float;
    public var startTimestamp:Float;

    public function new(exception:Any, startTimestamp:Float) {
        this.exception = exception;

        if (Std.is(exception, haxe.Exception)) {
            var exception_:haxe.Exception = exception;
            callStack = exception_.stack;
        } else {
            callStack = CallStack.exceptionStack();
        }

        programName = Sys.programPath();
        programArgs = Sys.args();
        version = Version.getVersion();
        platform = Sys.systemName();
        buildDate = Version.getBuildDate();
        buildHash = Version.getGitCommitHash();
        currentTimestamp = Sys.time();
        this.startTimestamp = startTimestamp;
    }

    public function getSummary():String {
        return Std.string(exception);
    }
}
