package wsave.netdata;

import haxe.io.Bytes;
import haxe.crypto.BaseCode;
import wsave.Exception;


class BaseEncoder {
    static var coderCache:BaseCode;
    static var baseCache:Int = 0;

    public static function base16decode(?data:Bytes, ?text:String, fold:Bool = false):Bytes {
        var data = data != null ? data : Bytes.ofString(text);
        var base16Coder = initBase16Coder();

        if (fold) {
            uppercaseBytes(data);
        }

        try {
            return base16Coder.decodeBytes(data);
        } catch (exception:String) {
            throw new ValueException(exception);
        }
    }

    public static function base16encode(data:Bytes):Bytes {
        var base16Coder = initBase16Coder();

        try {
            return base16Coder.encodeBytes(data);
        } catch (exception:String) {
            throw new ValueException(exception);
        }
    }

    static function uppercaseBytes(data:Bytes) {
        for (index in 0...data.length) {
            var byte = data.get(index);
            if ("a".code <= byte && byte <= "z".code) {
                // Clear lowercase bit with 0b11011111 mask.
                data.set(index, byte & 0xdf);
            }
        }
    }

    static function initBase16Coder():BaseCode {
        if (baseCache != 16) {
            coderCache = new BaseCode(Bytes.ofString("0123456789ABCDEF"));
            baseCache = 16;
        }
        return coderCache;
    }
}
