package wsave.text.codec;

using wsave.text.codec.CodecTools;


class UTF8Encoder implements Handler {
    public function new() {
    }

    public function process(stream:Stream, codePoint:Int):Result {
        if (codePoint == Stream.END_OF_STREAM) {
            return Result.Finished;
        } else if (codePoint.isASCII()) {
            return Result.Token(codePoint);
        }

        var count;
        var offset;

        if (0x80 <= codePoint && codePoint <= 0x7ff) {
            count = 1;
            offset = 0xc0;
        } else if (0x800 <= codePoint && codePoint <= 0xffff) {
            count = 2;
            offset = 0xe0;
        } else if (0x10000 <= codePoint && codePoint <= 0x10FFFF) {
            count = 3;
            offset = 0xf0;
        } else {
            throw new Exception("Should not reach here");
        }

        var firstByte = (codePoint >> (6 * count)) + offset;
        var bytes = [firstByte];

        while (count > 0) {
            var temp = codePoint >> (6 * (count - 1));
            bytes.push(0x80 | (temp & 0x3f));
            count -= 1;
        }

        return Result.Tokens(bytes);
    }
}
