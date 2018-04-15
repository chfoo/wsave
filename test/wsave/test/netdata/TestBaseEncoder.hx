package wsave.test.netdata;

import haxe.io.Bytes;
import utest.Assert;
import wsave.Exception;
import wsave.netdata.BaseEncoder;


class TestBaseEncoder {
    public function new() {
    }

    public function testBase16Encode() {
        var data = Bytes.alloc(4);
        data.set(1, 0x12);
        data.set(2, 0x4a);
        data.set(3, 0xff);

        var result = BaseEncoder.base16encode(data).toString();

        Assert.equals("00124AFF", result);
    }

    public function testBase16Decode() {
        var data = Bytes.alloc(4);
        data.set(1, 0x12);
        data.set(2, 0x4a);
        data.set(3, 0xff);

        var result = BaseEncoder.base16decode("00124AFF");

        Assert.equals(0, result.compare(data));
    }

    public function testBase16DecodeFold() {
        var data = Bytes.alloc(4);
        data.set(1, 0x12);
        data.set(2, 0x4a);
        data.set(3, 0xff);

        Assert.raises(function () {
            BaseEncoder.base16decode("00124aff");
        }, ValueException);

        var result = BaseEncoder.base16decode("00124aff", true);
        Assert.equals(0, result.compare(data));
    }
}
