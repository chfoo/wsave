package wsave.text.codec;

import haxe.Constraints.IMap;

using wsave.text.codec.CodecTools;


class SingleByteEncoder implements Handler {
    var table:IMap<Int,Int>;

    public function new(encoding:String) {
        table = IndexLoader.getCodePointToPointerMap(encoding);
    }

    public function process(stream:Stream, codePoint:Int):Result {
        if (codePoint == Stream.END_OF_STREAM) {
            return Result.Finished;
        } else if (codePoint.isASCII()) {
            return Result.Token(codePoint);
        } else {
            var pointer = table.get(codePoint);

            if (pointer == null) {
                return Result.Error(codePoint);
            }

            return Result.Token(pointer + 0x80);
        }
    }
}
