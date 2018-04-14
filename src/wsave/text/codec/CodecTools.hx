package wsave.text.codec;

class CodecTools {
    public static inline var NO_CODE_POINT = 1;

    public static function isASCII(token:Int):Bool {
        return token <= 0x7f;
    }
}
