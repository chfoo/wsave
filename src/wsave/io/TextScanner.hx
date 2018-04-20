package wsave.io;

import wsave.Exception;
import wsave.ds.CircularBuffer;

using unifill.Unifill;


private typedef StringInfo = {
    text:String,
    uLength:Int
};


class TextScanner {
    var buffer:CircularBuffer<Int>;
    public var length(default, null) = 0;
    var carriageReturnIndex = -1;
    var newLineIndex = -1;

    public function new() {
        buffer = new CircularBuffer();
    }

    public function pushString(text:String) {
        for (codePoint in text.uIterator()) {
            buffer.push(codePoint);
            length += 1;
        }

        scanNewlines();
    }

    public function shiftString(?length:Int):String {
        var outputBuffer = new StringBuf();
        var shiftedCodePoints = buffer.shiftRange(length);

        for (codePoint in shiftedCodePoints) {
            outputBuffer.uAddChar(codePoint);
        }

        carriageReturnIndex -= shiftedCodePoints.length;
        newLineIndex -= shiftedCodePoints.length;
        this.length -= shiftedCodePoints.length;

        Debug.assert(this.length >= 0, this.length);
        scanNewlines();

        return outputBuffer.toString();
    }

    public function indexOf(codePoint:Int):Int {
        var peekedCodePoints = buffer.peekRange();

        for (index in 0...peekedCodePoints.length) {
            if (codePoint == peekedCodePoints.get(index)) {
                return index;
            }
        }

        return -1;
    }

    function scanNewlines() {
        if (carriageReturnIndex < 0) {
            carriageReturnIndex = indexOf("\r".code);
        }

        if (newLineIndex < 0) {
            newLineIndex = indexOf("\n".code);
        }
    }

    public function isNewlineAmbiguous():Bool {
        return newLineIndex < 0
            && carriageReturnIndex >= 0
            && carriageReturnIndex == length - 1;
    }

    public function hasNewline():Bool {
        return newLineIndex >= 0 || carriageReturnIndex >= 0;
    }

    public function shiftLine(keepEnd:Bool = false):String {
        var shiftIndex = -1;
        var endLength = -1;

        if (!hasNewline()) {
            throw new BoundsException("No lines.");
        }

        if (carriageReturnIndex >= 0 && newLineIndex < 0) {
            shiftIndex = carriageReturnIndex;
            endLength = 1;
        } else if (carriageReturnIndex < 0 && newLineIndex >= 0) {
            shiftIndex = newLineIndex;
            endLength = 1;
        } else if (carriageReturnIndex > newLineIndex) {
            shiftIndex = newLineIndex;
            endLength = 1;
        } else if (carriageReturnIndex == newLineIndex - 1) {
            shiftIndex = carriageReturnIndex;
            endLength = 2;
        } else {
            shiftIndex = carriageReturnIndex;
            endLength = 1;
        }

        Debug.assert(shiftIndex >= 0, shiftIndex);
        Debug.assert(endLength > 0, endLength);

        if (keepEnd) {
            return shiftString(shiftIndex + endLength);
        } else {
            var output = shiftString(shiftIndex);
            shiftString(endLength);
            return output;
        }
    }
}
