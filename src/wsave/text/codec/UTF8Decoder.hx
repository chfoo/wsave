package wsave.text.codec;

class UTF8Decoder implements Handler {
    var codePoint = 0;
    var bytesSeen = 0;
    var bytesNeeded = 0;
    var lowerBoundary = 0x80;
    var upperBoundary = 0xbf;

    public function new() {
    }

    public function process(stream:Stream, byte:Int):Result {
        if (byte == Stream.END_OF_STREAM && bytesNeeded != 0) {
            bytesNeeded = 0;
            return Result.Error(CodecTools.INT_NULL);
        } else if (byte == Stream.END_OF_STREAM) {
            return Result.Finished;
        }

        if (bytesNeeded == 0) {
            return processZeroBytesNeeded(byte);
        } else if (!(lowerBoundary <= byte && byte <= upperBoundary)) {
            codePoint = bytesNeeded = bytesSeen = 0;
            lowerBoundary = 0x80;
            upperBoundary = 0xbf;
            stream.unshift(byte);

            return Result.Error(CodecTools.INT_NULL);
        }

        lowerBoundary = 0x80;
        upperBoundary = 0xbf;
        codePoint = (codePoint << 6) | (byte & 0x3f);
        bytesSeen += 1;

        if (bytesSeen != bytesNeeded) {
            return Result.Continue;
        }

        var resultCodePoint = codePoint;
        codePoint = bytesNeeded = bytesSeen = 0;

        return Result.Token(resultCodePoint);
    }

    function processZeroBytesNeeded(byte:Int) {
        if (0x00 <= byte && byte <=0x7f) {
            return Result.Token(byte);
        } else if (0xc2 <= byte && byte <=0xdf) {
            bytesNeeded = 1;
            codePoint = byte & 0x1f;
        } else if (0xe0 <= byte && byte <=0xef) {
            if (byte == 0xe0) {
                lowerBoundary = 0xa0;
            } else if (byte == 0xed) {
                upperBoundary = 0x9f;
            }

            bytesNeeded = 2;
            codePoint = byte & 0xf;
        } else if (0xf0 <= byte && byte <= 0xf4) {
            if (byte == 0xf0) {
                lowerBoundary = 0x90;
            } else if (byte == 0xf4) {
                upperBoundary = 0x8f;
            }

            bytesNeeded = 3;
            codePoint = byte & 0x7;
        } else {
            return Result.Error(CodecTools.INT_NULL);
        }

        return Result.Continue;
    }
}
