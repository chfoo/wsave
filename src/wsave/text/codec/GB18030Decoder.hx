package wsave.text.codec;

import haxe.Constraints.IMap;
import wsave.text.codec.IndexLoader;

using wsave.text.codec.CodecTools;


class GB18030Decoder implements Handler {
    var index:IMap<Int,Int>;
    var first = 0;
    var second = 0;
    var third = 0;
    var ranges:Array<GB18030Range>;

    public function new() {
        index = IndexLoader.getPointerToCodePointMap("gb18030");
        ranges = IndexLoader.getGB18030Ranges();
    }

    public function process(stream:Stream, byte:Int):Result {
        if (byte == Stream.END_OF_STREAM
                && first == 0 && second == 0 && third == 0) {
            return Result.Finished;
        } else if (byte == Stream.END_OF_STREAM
                && (first != 0 || second != 0 || third != 0)) {
            first = second = third = 0;
            return Result.Error(CodecTools.INT_NULL);
        } else if (third != 0) {
            return processThirdNotZero(stream, byte);
        } else if (second != 0) {
            return processSecondNotZero(stream, byte);
        } else if (first != 0) {
            return processFirstNotZero(stream, byte);
        }

        if (byte.isASCII()) {
            return Result.Token(byte);
        } else if (byte == 0x80) {
            return Result.Token(0x20ac);
        } else if (byte >= 0x81 && byte <= 0xFE) {
            first = byte;
            return Result.Continue;
        }

        return Result.Error(CodecTools.INT_NULL);
    }

    function processThirdNotZero(stream:Stream, byte:Int) {
        if (!(byte >= 0x30 && byte <= 0x39)) {
            stream.unshift(byte);
            stream.unshift(third);
            stream.unshift(second);

            first = second = third = 0;

            return Result.Error(CodecTools.INT_NULL);
        }

        var pointer = ((first - 0x81) * (10 * 126 * 10))
            + ((second - 0x30) * (10 * 126))
            + ((third - 0x81) * 10)
            + byte - 0x30;

        var codePoint = getRangesCodePoint(pointer);

        // This following line isn't in the spec. Bug?
        first = second = third = 0;

        if (codePoint == CodecTools.INT_NULL) {
            return Result.Error(CodecTools.INT_NULL);
        }

        return Result.Token(codePoint);
    }

    function processSecondNotZero(stream:Stream, byte:Int) {
        if (byte >= 0x81 && byte <= 0xFE) {
            third = byte;
            return Result.Continue;
        }

        stream.unshift(second);
        stream.unshift(byte);
        first = second = 0;

        return Result.Error(CodecTools.INT_NULL);
    }

    function processFirstNotZero(stream:Stream, byte:Int) {
        if (byte >= 0x30 && byte <= 0x39) {
            second = byte;
            return Result.Continue;
        }

        var lead = first;
        var pointer = CodecTools.INT_NULL;
        first = 0;
        var offset = byte < 0x7f ? 0x40 : 0x41;

        if (byte >= 0x40 && byte <= 0x7E || byte >= 0x80 && byte <= 0xFE) {
            pointer = (lead - 0x81) * 190 + (byte - offset);
        }

        var codePoint;

        if (pointer == CodecTools.INT_NULL) {
            codePoint = CodecTools.INT_NULL;
        } else {
            if (index.exists(pointer)) {
                codePoint = index.get(pointer);
            } else {
                codePoint = CodecTools.INT_NULL;
            }
        }

        if (codePoint != CodecTools.INT_NULL) {
            return Result.Token(codePoint);
        }

        if (byte.isASCII()) {
            stream.unshift(byte);
        }

        return Result.Error(CodecTools.INT_NULL);
    }

    function getRangesCodePoint(pointer:Int):Int {
        if (pointer > 39419 && pointer < 189000 || pointer > 1237575) {
            return CodecTools.INT_NULL;
        }

        if (pointer == 7475) {
            return 0xE7C7;
        }

        var offset = CodecTools.INT_NULL;
        var codePointOffset = CodecTools.INT_NULL;

        for (range in ranges) {
            if (range.pointer <= pointer) {
                offset = range.pointer;
                codePointOffset = range.codePoint;
            } else {
                break;
            }
        }

        return codePointOffset + pointer - offset;
    }
}
