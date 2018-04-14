package wsave.netdata;

using StringTools;
using wsave.Exception;
using wsave.text.StringTextTools;


private typedef KeyValuePair = {key:String, value:String};


class NameValueRecordParser {
    var record:NameValueRecord;
    var key:String;
    var valueBuffer:StringBuf;

    public function new() {
    }

    public function parse(text:String):NameValueRecord {
        record = new NameValueRecord();
        key = null;
        valueBuffer = null;

        var lines = text.splitLines();
        var isInFold = false;

        if (lines.length > 0 && isLineFolded(lines[0])) {
            throw new ValueException('Unexpected folded line.');
        }

        for (index in 0...lines.length) {
            var line = lines[index];
            var nextLine = index + 1 < lines.length ? lines[index + 1] : null;

            if (isLineFolded(line)) {
                pushBufferedValue(line.trim());
                continue;
            }

            if (line.trim().length == 0) {
                continue;
            }

            if (isInFold) {
                isInFold = false;
                popBufferedValue();
            }

            var pair = splitKeyValue(line);

            if (nextLine != null && isLineFolded(nextLine)) {
                key = pair.key;
                initBufferedValue(pair.value);
                isInFold = true;
            } else {
                record.add(pair.key, pair.value);
            }
        }

        if (valueBuffer != null) {
            popBufferedValue();
        }

        return record;
    }

    function initBufferedValue(value:String) {
        Debug.assert(valueBuffer == null);
        valueBuffer = new StringBuf();
        valueBuffer.add(value);
    }

    function pushBufferedValue(value:String) {
        Debug.assert(valueBuffer != null);
        valueBuffer.add(" ");
        valueBuffer.add(value);
    }

    function popBufferedValue() {
        Debug.assert(key != null);
        Debug.assert(valueBuffer != null);
        record.add(key, valueBuffer.toString());
        key = null;
        valueBuffer = null;
    }

    static function splitKeyValue(text:String):KeyValuePair {
        var colonIndex = text.indexOf(":");

        if (colonIndex >= 0) {
            var key = text.substring(0, colonIndex).trim();
            var value = text.substring(colonIndex + 1).trim();
            return { key: key, value: value };
        } else {
            var key = text.trim();
            return { key: key, value: "" };
        }
    }

    static function isLineFolded(text:String):Bool {
        return text.startsWith(" ") || text.startsWith("\t");
    }
}
