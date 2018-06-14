package wsave.text.codec;

import haxe.Constraints.IMap;
import wsave.text.codec.IndexLoader;

using wsave.text.codec.CodecTools;


class GB18030Encoder implements Handler {
    var gbkFlag = false;
    var index:IMap<Int,Int>;
    var ranges:Array<GB18030Range>;

    public function new(gbkFlag:Bool = false) {
        this.gbkFlag = gbkFlag;
        index = IndexLoader.getCodePointToPointerMap("gb18030");
        ranges = IndexLoader.getGB18030Ranges();
    }

    public function process(stream:Stream, codePoint:Int):Result {
        if (codePoint == Stream.END_OF_STREAM) {
            return Result.Finished;
        } else if (codePoint.isASCII()) {
            return Result.Token(codePoint);
        } else if (codePoint == 0xE5E5) {
            return Result.Error(codePoint);
        } else if (gbkFlag && codePoint == 0x20AC) {
            return Result.Token(0x80);
        }

        var pointer;

        if (index.exists(codePoint)) {
            pointer = index.get(codePoint);
        } else {
            pointer = CodecTools.INT_NULL;
        }

        if (pointer != CodecTools.INT_NULL) {
            var lead = Std.int(pointer / 190) + 0x81;
            var trail = pointer % 190;
            var offset = trail < 0x3F ? 0x40 : 0x41;

            return Result.Tokens([lead, trail + offset]);
        }

        if (gbkFlag) {
            return Result.Error(codePoint);
        }

        pointer = getIndexRangesPointer(codePoint);
        var byte1 = Std.int(pointer / (10 * 126 * 10));
        pointer %= 10 * 126 * 10;
        var byte2 = Std.int(pointer / (10 * 126));
        pointer %= 10 * 126;
        var byte3 = Std.int(pointer / 10);
        var byte4 = pointer % 10;

        return Result.Tokens([byte1 + 0x81, byte2 + 0x30, byte3 + 0x81, byte4 + 0x30]);
    }

    function getIndexRangesPointer(codePoint:Int):Int {
        if (codePoint == 0xE7C7) {
            return 7457;
        }

        var offset = CodecTools.INT_NULL;
        var pointerOffset = CodecTools.INT_NULL;

        for (range in ranges) {
            if (range.codePoint <= codePoint) {
                offset = range.codePoint;
                pointerOffset = range.pointer;
            } else {
                break;
            }
        }

        return pointerOffset + codePoint - offset;
    }
}
