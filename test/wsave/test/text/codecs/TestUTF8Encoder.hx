package wsave.test.text.codecs;

import utest.Assert;
import wsave.text.codec.Encoder;
import wsave.text.codec.UTF8Encoder;


class TestUTF8Encoder {
    public function new() {
    }

    public function testSimple() {
        var encoderHandler = new UTF8Encoder();
        var encoder = new Encoder(encoderHandler);

        var resultData = encoder.encode("Hello world! 💾");

        Assert.equals("48656c6c6f20776f726c642120f09f92be", resultData.toHex());
    }

    public function testBoundary() {
        var encoderHandler = new UTF8Encoder();
        var encoder = new Encoder(encoderHandler);

        var resultData = encoder.encode(
            "\u{0000}\u{007f}" +
            "\u{0080}\u{07FF}" +
            "\u{0800}\u{FFFF}" +
            "\u{10000}\u{10FFFF}"
            );

        Assert.equals("007fc280dfbfe0a080efbfbff0908080f48fbfbf", resultData.toHex());
    }
}
