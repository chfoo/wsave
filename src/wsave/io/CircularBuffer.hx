package wsave.io;

import haxe.io.Bytes;


class CircularBuffer {
    var buffer:Bytes;
    var logicalStartIndex = 0;
    public var logicalLength(default, null) = 0;
    var defaultSize:Int;

    public function new(size:Int = 1024) {
        buffer = Bytes.alloc(size);
        defaultSize = size;
    }

    public function pushBytes(data:Bytes, position:Int = 0, ?length:Int) {
        if (length == null) {
            length = data.length - position;
        }

        if (length + logicalLength > buffer.length) {
            resize(length + logicalLength);
        }

        for (index in 0...length) {
            var bufferIndex = (logicalStartIndex + logicalLength + index) % buffer.length;

            buffer.set(bufferIndex, data.get(position + index));
        }

        logicalLength += length;
    }

    public function pushString(text:String) {
        pushBytes(Bytes.ofString(text));
    }

    public function shiftBytes(?amount:Int):Bytes {
        var data = copyCurrent(amount);
        var length = data.length;

        logicalStartIndex += length;
        logicalLength -= length;

        logicalStartIndex %= buffer.length;

        Debug.assert(logicalStartIndex >= 0, logicalStartIndex);
        Debug.assert(logicalLength >= 0, logicalLength);

        return data;
    }

    public function peek(?amount:Int):Bytes {
        return copyCurrent(amount);
    }

    function copyCurrent(?amount:Int):Bytes {
        if (amount == null) {
            amount = logicalLength;
        }

        amount = Std.int(Math.min(logicalLength, amount));

        var data = Bytes.alloc(amount);

        for (index in 0...amount) {
            var bufferIndex = (logicalStartIndex + index) % buffer.length;
            data.set(index, buffer.get(bufferIndex));
        }

        return data;
    }

    public function clear() {
        buffer = Bytes.alloc(defaultSize);
        logicalStartIndex = logicalLength = 0;
    }

    function resize(size:Int) {
        Debug.assert(size >= logicalLength);

        var newBuffer = Bytes.alloc(size);

        // Copy from old to new buffer
        for (index in 0...logicalLength) {
            var logicalIndex = logicalStartIndex + index;
            var oldIndex = logicalIndex % buffer.length;

            newBuffer.set(index, buffer.get(oldIndex));
        }

        buffer = newBuffer;
        logicalStartIndex = 0;
    }
}
