package wsave.text.codec;

import haxe.Constraints.IMap;

using wsave.text.codec.CodecTools;


class SingleByteDecoder implements Handler {
    var table:IMap<Int,Int>;

    public function new(encoding:String) {
        table = IndexLoader.getPointerToCodePointMap(encoding);
    }

    public function process(stream:Stream, byte:Int):Result {
        if (byte == Stream.END_OF_STREAM) {
            return Result.Finished;
        } else if (byte.isASCII()) {
            return Result.Token(byte);
        } else {
            var pointer = byte - 0x80;
            var codePoint = table.get(pointer);

            if (codePoint == null) {
                return Result.Error(CodecTools.INT_NULL);
            }

            return Result.Token(codePoint);
        }
    }
}
