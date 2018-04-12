package wsave.test.io;

import haxe.io.Bytes;
import utest.Assert;

using wsave.io.BytesTools;


class TestBytesTools {
    public function new() {
    }

    public function testCharIndexOf() {
        var bytes = Bytes.ofString("a_b_c");

        Assert.equals(0, bytes.charIndexOf("a".code));
        Assert.equals(2, bytes.charIndexOf("b".code));
        Assert.equals(4, bytes.charIndexOf("c".code));
        Assert.equals(-1, bytes.charIndexOf("z".code));
    }

    public function testEndsWith() {
        var bytes = Bytes.ofString("a_b_c");

        Assert.isTrue(bytes.endsWith("c".code));
        Assert.isFalse(bytes.endsWith("z".code));
    }

    public function testEndsWith2() {
        var bytes = Bytes.ofString("a_b_c");

        Assert.isTrue(bytes.endsWith2("_".code, "c".code));
        Assert.isFalse(bytes.endsWith2("_".code, "z".code));
    }
}
