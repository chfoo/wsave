package wsave.test.text.codecs;

import haxe.io.Bytes;
import utest.Assert;
import wsave.text.codec.Encoder;
import wsave.text.TextExceptions;
import wsave.text.codec.GB18030Encoder;


class TestGB18030Encoder {
    public function new() {
    }

    public function testEncode() {
        var bytes = Bytes.alloc(7);
        bytes.set(0, " ".code);
        bytes.set(1, 0x81); // 丂
        bytes.set(2, 0x40);
        bytes.set(3, 0x84); // ︔
        bytes.set(4, 0x31);
        bytes.set(5, 0x83);
        bytes.set(6, 0x30);

        var handler = new GB18030Encoder();
        var encoder = new Encoder(handler);

        Assert.equals(0, bytes.compare(encoder.encode(" 丂︔")));
    }

    public function testEncodeGBK() {
        var bytes = Bytes.alloc(5);
        bytes.set(0, " ".code);
        bytes.set(1, 0x81); // 丂
        bytes.set(2, 0x40);
        bytes.set(3, 0x8F); // 忦
        bytes.set(4, 0xF0);

        var handler = new GB18030Encoder(true);
        var encoder = new Encoder(handler);

        Assert.equals(0, bytes.compare(encoder.encode(" 丂忦")));
    }

    public function testEncodeGBKError() {
        var handler = new GB18030Encoder(true);
        var encoder = new Encoder(handler);
        Assert.raises(encoder.encode.bind(" 丂︔"), EncodingException);
    }
}
