package wsave;

import haxe.CallStack.StackItem;
import haxe.Exception;


class Exception extends haxe.Exception {
    @:noUsing
    static public function wrap (e:Dynamic, exceptionStack:Array<StackItem> = null):haxe.Exception {
        return haxe.Exception.wrap(e, exceptionStack);
    }

    override function toString():String {
        return '[${Type.getClassName(Type.getClass(this))} ${message}]';
    }
}


class SystemException extends Exception {
}


class BoundsException extends Exception {
}


class ValueException extends Exception {
}


class NotImplementedException extends Exception {
}
