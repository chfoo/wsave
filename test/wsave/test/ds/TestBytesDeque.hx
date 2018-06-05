package wsave.test.ds;

import haxe.io.Bytes;
import wsave.Exception;
import wsave.ds.BytesDeque;
import utest.Assert;

using commonbox.utils.OptionTools;


class TestBytesDeque {
    public function new() {
    }

    public function testPushShift() {
        var data1 = Bytes.ofString("hello");
        var data2 = Bytes.ofString("world");
        var data3 = Bytes.ofString("!");
        var buffer = new BytesDeque();

        for (dummy in 0...50) {
            buffer.pushBytes(data1);

            var shiftedData = buffer.shiftBytes(5);
            assertBytesEqual(data1, shiftedData);

            buffer.pushBytes(data2);
            buffer.pushBytes(data3);

            shiftedData = buffer.shiftBytes(5);
            assertBytesEqual(data2, shiftedData);

            shiftedData = buffer.shiftBytes();
            assertBytesEqual(data3, shiftedData);
        }

        for (dummy in 0...50) {
            buffer.push(123);

            var shiftedItem = buffer.shift();

            Assert.equals(123, shiftedItem.getSome());
        }
    }

    public function testShiftBounds() {
        var data1 = Bytes.ofString("hello");
        var buffer = new BytesDeque();

        buffer.pushBytes(data1);

        var shiftedData = buffer.shiftBytes(9999);
        assertBytesEqual(data1, shiftedData);
    }

    @Ignored
    function testShiftEmpty() {
        var buffer = new BytesDeque(6);
        var shiftedData = buffer.shiftBytes();
        Assert.equals(0, shiftedData.length);

        Assert.raises(function () {
            buffer.shift();
        }, BoundsException);
    }

    public function testPeek() {
        var data1 = Bytes.ofString("hello");
        var buffer = new BytesDeque(6);
        buffer.pushBytes(data1);

        var peekedData = buffer.peekBytes(2);
        assertBytesEqual(peekedData, Bytes.ofString("he"));

        Assert.equals("h".code, buffer.first());
    }

    public function testPeekEmpty() {
        var buffer = new BytesDeque();

        var peekedData = buffer.peekBytes(2);
        Assert.equals(0, peekedData.length);
    }

    function assertBytesEqual(expected:Bytes, other:Bytes) {
        Assert.equals(expected.length, other.length);
        Assert.equals(0, expected.compare(other));
    }
}
