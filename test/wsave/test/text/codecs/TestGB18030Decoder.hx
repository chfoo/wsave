package wsave.test.text.codecs;

import haxe.io.Bytes;
import utest.Assert;
import wsave.text.codec.Decoder;
import wsave.text.codec.GB18030Decoder;


class TestGB18030Decoder {
    public function new() {
    }

    public function testDecode() {
        var bytes = Bytes.alloc(7);
        bytes.set(0, " ".code);
        bytes.set(1, 0x81); // 丂
        bytes.set(2, 0x40);
        bytes.set(3, 0x84); // ︔
        bytes.set(4, 0x31);
        bytes.set(5, 0x83);
        bytes.set(6, 0x30);

        var handler = new GB18030Decoder();
        var decoder = new Decoder(handler);

        Assert.equals(" 丂︔", decoder.decode(bytes));
    }
}
