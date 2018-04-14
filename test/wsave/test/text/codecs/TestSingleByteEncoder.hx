package wsave.test.text.codecs;

import haxe.io.Bytes;
import utest.Assert;
import wsave.text.codec.Encoder;
import wsave.text.codec.SingleByteEncoder;
import wsave.text.TextExceptions;


class TestSingleByteEncoder {
    public function new() {
    }

    public function testWindows1252() {
        var bytes = Bytes.alloc(8);
        bytes.set(1, " ".code);
        bytes.set(2, "A".code);
        bytes.set(3, "a".code);
        bytes.set(4, 0x80); // €
        bytes.set(5, 0x81); // U+0081
        bytes.set(6, 0xc0); // À
        bytes.set(7, 0xff); // ÿ

        var handler = new SingleByteEncoder("windows-1252");
        var encoder = new Encoder(handler);

        Assert.equals(0, bytes.compare(encoder.encode("\u0000 Aa€\u0081Àÿ")));
    }

    public function testException() {
        var handler = new SingleByteEncoder("windows-1252");
        var encoder = new Encoder(handler);

        Assert.raises(function () {
            encoder.encode("💩");
        }, EncodingException);
    }
}
