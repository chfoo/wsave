package wsave.logging;

import haxe.CallStack;
import haxe.Log;
import haxe.Json;


class ConsoleHandler implements Handler {
    public var currentLine(default, null):String;

    public function new() {
    }

    public function logRecord(record:Record) {
        var buffer = new StringBuf();

        buffer.add(record.level.toString());
        buffer.add(" ");
        buffer.add(record.position.fileName);
        buffer.add(":");
        buffer.add(record.position.lineNumber);
        buffer.add(" ");
        buffer.add(record.namespace);
        buffer.add(" ");
        buffer.add(record.tag);
        buffer.add(" ");

        if (record.args != null) {
            for (key in record.args.keys()) {
                buffer.add(key);
                buffer.add("=");
                buffer.add(Json.stringify(record.args.get(key)));
                buffer.add(" ");
            }
        }

        if (record.stack != null) {
            buffer.add("\r\n");
            buffer.add(CallStack.toString(record.stack));
            buffer.add("\r\n-----");
        }

        var line = buffer.toString();
        currentLine = line;

        Log.trace(line, record.position);
    }
}
