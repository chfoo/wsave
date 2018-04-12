package wsave.logging;

import haxe.CallStack;
import haxe.PosInfos;


class Record {
    public var level:Level;
    public var namespace:String;
    public var tag:String;
    public var args:Map<String,Dynamic>;
    public var stack:Array<StackItem>;
    public var position:PosInfos;

    public function new(level:Level, namespace:String, tag:String,
            ?args:Map<String,Dynamic>, ?stack:Array<StackItem>,
            ?position:PosInfos) {
        this.level = level;
        this.namespace = namespace;
        this.tag = tag;
        this.args = args;
        this.stack = stack;
        this.position = position;
    }
}
