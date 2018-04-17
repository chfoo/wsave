package wsave.ds;

import wsave.Exception;


class BaseCircularBuffer<T,B> {
    var buffer:B;
    var logicalStartIndex = 0;
    public var logicalLength(default, null) = 0;
    var defaultSize:Int;

    public function new(size:Int = 1024) {
        buffer = getNewBuffer(size);
        defaultSize = size;
    }

    function getNewBuffer(size:Int):B {
        throw new NotImplementedException();
    }

    function getLength(data:B):Int {
        throw new NotImplementedException();
    }

    function dataSet(data:B, index:Int, value:T) {
        throw new NotImplementedException();
    }

    function dataGet(data:B, index:Int):T {
        throw new NotImplementedException();
    }

    public function pushRange(data:B, position:Int = 0, ?length:Int) {
        if (length == null) {
            length = getLength(data) - position;
        }

        Debug.assert(position >= 0, position);
        Debug.assert(length >= 0, length);

        if (length + logicalLength > getLength(buffer)) {
            resize(length + logicalLength);
        }

        for (index in 0...length) {
            var bufferIndex = (logicalStartIndex + logicalLength + index) % getLength(buffer);

            dataSet(buffer, bufferIndex, dataGet(data, position + index));
        }

        logicalLength += length;
    }

    public function shiftRange(?amount:Int):B {
        var data = copyCurrent(amount);
        var length = getLength(data);

        logicalStartIndex += length;
        logicalLength -= length;

        logicalStartIndex %= getLength(buffer);

        Debug.assert(logicalStartIndex >= 0, logicalStartIndex);
        Debug.assert(logicalLength >= 0, logicalLength);

        return data;
    }

     public function peek(?amount:Int):B {
        return copyCurrent(amount);
    }

    function copyCurrent(?amount:Int):B {
        if (amount == null) {
            amount = logicalLength;
        }

        amount = Std.int(Math.min(logicalLength, amount));

        var data = getNewBuffer(amount);

        for (index in 0...amount) {
            var bufferIndex = (logicalStartIndex + index) % getLength(buffer);
            dataSet(data, index, dataGet(buffer, bufferIndex));
        }

        return data;
    }

    public function clear() {
        buffer = getNewBuffer(defaultSize);
        logicalStartIndex = logicalLength = 0;
    }

    function resize(size:Int) {
        Debug.assert(size >= logicalLength);

        var newBuffer = getNewBuffer(size);

        // Copy from old to new buffer
        for (index in 0...logicalLength) {
            var logicalIndex = logicalStartIndex + index;
            var oldIndex = logicalIndex % getLength(buffer);

            dataSet(newBuffer, index, dataGet(buffer, oldIndex));
        }

        buffer = newBuffer;
        logicalStartIndex = 0;
    }

}
