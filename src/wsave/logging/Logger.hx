package wsave.logging;

import haxe.CallStack;
import haxe.PosInfos;


class Logger {
    var namespace:String;
    var handlers:Array<Handler>;

    public function new(namespace:String, ?handlers:Array<Handler>) {
        this.namespace = namespace;

        if (handlers != null) {
            this.handlers = handlers.copy();
        } else {
            this.handlers = [];
        }
    }

    public function addHandler(handler:Handler) {
        if (handlers.indexOf(handler) < 0) {
            handlers.push(handler);
        }
    }

    public function removeHandler(handler:Handler) {
        handlers.remove(handler);
    }

    public function log(level:Level, tag:String, ?args:Map<String,Dynamic>,
            logStack:Bool = false, ?infos:PosInfos) {
        var stack;

        if (logStack) {
            stack = CallStack.exceptionStack();
        } else {
            stack = null;
        }

        var record = new Record(level, namespace, tag, args, stack, infos);

        for (handler in handlers) {
            handler.logRecord(record);
        }
    }

    public function critical(tag:String, ?args:Map<String,Dynamic>,
            logStack:Bool = false, ?infos:PosInfos) {
        log(Level.Critical, tag, args, logStack, infos);
    }

    public function error(tag:String, ?args:Map<String,Dynamic>,
            logStack:Bool = false, ?infos:PosInfos) {
        log(Level.Error, tag, args, logStack, infos);
    }

    public function warning(tag:String, ?args:Map<String,Dynamic>,
            logStack:Bool = false, ?infos:PosInfos) {
        log(Level.Warning, tag, args, logStack, infos);
    }

    public function info(tag:String, ?args:Map<String,Dynamic>,
            logStack:Bool = false, ?infos:PosInfos) {
        log(Level.Info, tag, args, logStack, infos);
    }

    public function debug(tag:String, ?args:Map<String,Dynamic>,
            logStack:Bool = false, ?infos:PosInfos) {
        log(Level.Debug, tag, args, logStack, infos);
    }

    public function verbose(tag:String, ?args:Map<String,Dynamic>,
            logStack:Bool = false, ?infos:PosInfos) {
        log(Level.Verbose, tag, args, logStack, infos);
    }
}
