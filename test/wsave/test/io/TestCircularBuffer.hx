package wsave.test.io;

import haxe.io.Bytes;
import utest.Assert;
import wsave.io.CircularBuffer;


class TestCircularBuffer {
    public function new() {
    }

    public function testPushShift() {
        var data1 = Bytes.ofString("hello");
        var data2 = Bytes.ofString("world");
        var data3 = Bytes.ofString("!");
        var buffer = new CircularBuffer(17);

        for (dummy in 0...50) {
            buffer.pushBytes(data1);

            var shiftedData = buffer.shiftBytes(5);
            Assert.equals(0, shiftedData.compare(data1));

            buffer.pushBytes(data2);
            buffer.pushBytes(data3);

            shiftedData = buffer.shiftBytes(5);
            Assert.equals(0, shiftedData.compare(data2));

            shiftedData = buffer.shiftBytes();
            Assert.equals(0, shiftedData.compare(data3));
        }
    }

    public function testResize() {
        var data = Bytes.ofString("abc");
        var buffer = new CircularBuffer(5);

        for (dummy in 0...10) {
            buffer.pushBytes(data);
        }

        Assert.equals(30, buffer.logicalLength);

        for (dummy in 0...10) {
            var data = buffer.shiftBytes(3);
            Assert.equals("abc", data.toString());
        }

        Assert.equals(0, buffer.logicalLength);
    }

    public function testShiftBounds() {
        var data1 = Bytes.ofString("hello");
        var buffer = new CircularBuffer(6);

        buffer.pushBytes(data1);

        var shiftedData = buffer.shiftBytes(9999);
        Assert.equals(0, shiftedData.compare(data1));
    }

    public function testShiftEmpty() {
        var buffer = new CircularBuffer(6);
        var shiftedData = buffer.shiftBytes();
        Assert.equals(0, shiftedData.length);
    }

    public function testClear() {
        var data1 = Bytes.ofString("hello");
        var buffer = new CircularBuffer(6);

        buffer.pushBytes(data1);

        var shiftedData = buffer.shiftBytes(5);
        Assert.equals(0, shiftedData.compare(data1));

        buffer.clear();

        shiftedData = buffer.shiftBytes();
        Assert.equals(0, shiftedData.length);
    }
}
