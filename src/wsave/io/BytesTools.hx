package wsave.io;

import haxe.io.Bytes;


class BytesTools {
    public static function charIndexOf(bytes:Bytes, char:Int):Int {
        for (index in 0...bytes.length) {
            if (bytes.get(index) == char) {
                return index;
            }
        }

        return -1;
    }

    public static function endsWith(bytes:Bytes, char:Int):Bool {
        return bytes.length >= 1 && bytes.get(bytes.length - 1) == char;
    }

    public static function endsWith2(bytes:Bytes, char1:Int, char2:Int):Bool {
        return bytes.length >= 2
            && bytes.get(bytes.length - 2) == char1
            && bytes.get(bytes.length - 1) == char2;
    }
}
