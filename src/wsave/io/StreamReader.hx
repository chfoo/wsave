package wsave.io;

import haxe.io.Bytes;
import haxe.io.Eof;
import haxe.io.Input;
import wsave.io.IOExceptions;

using wsave.io.BytesTools;


class StreamReader implements IInputStream {
    public var chunkSize = 8192;
    public var maxBufferSize = 1048576;

    var input:Input;
    var pendingDataBuffer:CircularBuffer;

    public function new(input:Input) {
        this.input = input;
        pendingDataBuffer = new CircularBuffer();
    }

    public function read(amount:Int = -1, exact:Bool = false):Bytes {
        if (amount >= 0) {
            if (exact) {
                return readExact(amount);
            } else {
                return readBestEffort(amount);
            }
        } else {
            return readAll();
        }
    }

    function readRaw(amount:Int):Bytes {
        Debug.assert(amount >= 0, amount);

        if (amount == 0) {
            return Bytes.alloc(0);
        }

        var buffer = Bytes.alloc(amount);
        var amountRead;
        try {
            amountRead = input.readBytes(buffer, 0, amount);
        } catch (exception:Eof) {
            throw wrapEndOfFile(exception);
        }

        Debug.assert(amountRead != 0);

        return buffer.sub(0, amountRead);
    }

    function readBuffered(amount:Int):Bytes {
        Debug.assert(amount >= 0, amount);

        var buffer = Bytes.alloc(amount);
        var bufferData = pendingDataBuffer.shiftBytes(amount);

        buffer.blit(0, bufferData, 0, bufferData.length);

        var remainingAmount = amount - bufferData.length;
        var readData = readRaw(remainingAmount);

        buffer.blit(bufferData.length, readData, 0, readData.length);

        return buffer.sub(0, bufferData.length + readData.length);
    }

    function readAll():Bytes {
        while (true) {
            var data;

            try {
                data = readRaw(chunkSize);
            } catch (exception:EndOfFile) {
                if (pendingDataBuffer.logicalLength == 0) {
                    throw exception;
                } else {
                    break;
                }
            }

            pendingDataBuffer.pushBytes(data);

            if (maxBufferSize > 0 && pendingDataBuffer.logicalLength > maxBufferSize) {
                throw new BufferFull();
            }
        }

        return pendingDataBuffer.shiftBytes();
    }

    function readExact(amount:Int):Bytes {
        Debug.assert(amount >= 0);

        var buffer = Bytes.alloc(amount);
        var bufferData = pendingDataBuffer.shiftBytes(amount);
        buffer.blit(0, bufferData, 0, bufferData.length);
        var index = bufferData.length;

        while (index < amount) {
            var remaining = amount - index;
            Debug.assert(remaining > 0, remaining);
            var data;

            try {
                data = readRaw(remaining);
            } catch (exception:EndOfFile) {
                if (index == 0) {
                    throw new EndOfFile();
                } else {
                    throw new IncompleteRead(pendingDataBuffer.shiftBytes());
                }
            }

            pendingDataBuffer.pushBytes(data);
            index += data.length;
        }

        return pendingDataBuffer.shiftBytes();
    }

    function readBestEffort(amount:Int):Bytes {
        return readBuffered(amount);
    }

    public function readLine(keepEnd:Bool = false):Bytes {
        var checkedBuffer = false;
        var index = 0;

        while (true) {
            var data;

            if (checkedBuffer) {
                data = readChunkIntoBuffer();
            } else {
                checkedBuffer = true;
                data = pendingDataBuffer.peek();
            }

            if (isDataEndOnCarriageReturn(data)) {
                data = readExtraByteToData(data);
            }

            var separatedData = separateAtNewline(data, index, keepEnd);

            if (separatedData != null) {
                return separatedData;
            }

            index += data.length;
        }
    }

    public function readUntil(separator:Int = "\n".code, keepEnd:Bool = false):Bytes {
        var checkedBuffer = false;
        var index = 0;

        while (true) {
            var data;
            if (checkedBuffer) {
                data = readChunkIntoBuffer();
            } else {
                data = pendingDataBuffer.peek();
                checkedBuffer = true;
            }

            var separatedData = separateAtSeparator(data, separator, index, keepEnd);

            if (separatedData != null) {
                return separatedData;
            }

            index += data.length;
        }
    }

    function getChunkSizeAvailable():Int {
        if (maxBufferSize > 0) {
            var spaceAvailable = maxBufferSize - pendingDataBuffer.logicalLength;
            var chunkSizeAvailable = Std.int(
                Math.max(0, Math.min(spaceAvailable, chunkSize))
            );

            return chunkSizeAvailable;
        } else {
            return chunkSize;
        }
    }

    function wrapEndOfFile(exception:Eof):EndOfFile {
        return new EndOfFile("", Exception.wrap(exception));
    }

    function readChunkIntoBuffer(ignoreError:Bool = false):Bytes {
        var currentChunkSize = getChunkSizeAvailable();

        if (currentChunkSize <= 0) {
            throw new BufferFull("Data buffer is full.");
        }

        var data;

        try {
            data = readRaw(currentChunkSize);
        } catch (exception:EndOfFile) {
            if (pendingDataBuffer.logicalLength > 0) {
                throw new IncompleteRead(pendingDataBuffer.shiftBytes());
            } else {
                throw exception;
            }
        }

        pendingDataBuffer.pushBytes(data);
        return data;
    }

    function separateAtSeparator(data:Bytes, separator:Int, position:Int, keepEnd:Bool):Null<Bytes> {
        var separatorIndex = data.charIndexOf(separator);

        if (separatorIndex >= 0) {
            var targetData = pendingDataBuffer.shiftBytes(position + separatorIndex + 1);

            if (keepEnd) {
                return targetData;
            } else {
                return targetData.sub(0, targetData.length - 1);
            }
        }

        return null;
    }

    function isDataEndOnCarriageReturn(data:Bytes):Bool {
        var index = data.charIndexOf("\r".code);
        return index >=0 && index == data.length - 1;
    }

    function readExtraByteToData(data:Bytes):Bytes {
        var extraData;
        try {
            extraData = readRaw(1);
        } catch (exception:EndOfFile) {
            return data;
        }

        pendingDataBuffer.pushBytes(extraData);

        var newData = Bytes.alloc(data.length + 1);
        newData.blit(0, data, 0, data.length);
        newData.set(newData.length - 1, extraData.get(0));
        return newData;
    }

    function separateAtNewline(data:Bytes, position:Int, keepEnd:Bool):Null<Bytes> {
        var separatedData = separateAtSeparator(data, "\n".code, position, keepEnd);

        if (separatedData != null && !keepEnd
                && separatedData.endsWith("\r".code)) {
            return separatedData.sub(0, separatedData.length - 1);
        } else if (separatedData != null) {
            return separatedData;
        }

        return separateAtSeparator(data, "\r".code, position, keepEnd);
    }
}
