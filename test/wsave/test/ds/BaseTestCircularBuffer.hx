package wsave.test.ds;

import wsave.Exception;
import wsave.ds.BaseCircularBuffer;
import utest.Assert;


class BaseTestCircularBuffer<T,B> {
    public function new() {
    }

    function newCircularBuffer(size:Int):BaseCircularBuffer<T,B> {
        throw new NotImplementedException();
    }

    function newData(text:String):B {
        throw new NotImplementedException();
    }

    function newItem(value:Int):T {
        throw new NotImplementedException();
    }

    function getDataLength(data:B):Int {
        throw new NotImplementedException();
    }

    function assertDataEqual(data1:B, data2:B) {
        Assert.fail();
    }

    @Ignored
    function testPushShift() {
        var data1 = newData("hello");
        var data2 = newData("world");
        var data3 = newData("!");
        var buffer = newCircularBuffer(17);

        for (dummy in 0...50) {
            buffer.pushRange(data1);

            var shiftedData = buffer.shiftRange(5);
            assertDataEqual(shiftedData, data1);

            buffer.pushRange(data2);
            buffer.pushRange(data3);

            shiftedData = buffer.shiftRange(5);
            assertDataEqual(shiftedData, data2);

            shiftedData = buffer.shiftRange();
            assertDataEqual(shiftedData, data3);
        }

        for (dummy in 0...50) {
            buffer.push(newItem(123));

            var shiftedItem = buffer.shift();

            Assert.equals(newItem(123), shiftedItem);
        }
    }

    @Ignored
    function testResize() {
        var data = newData("abc");
        var buffer = newCircularBuffer(5);

        for (dummy in 0...10) {
            buffer.pushRange(data);
        }

        Assert.equals(30, buffer.logicalLength);

        for (dummy in 0...10) {
            var data = buffer.shiftRange(3);
            assertDataEqual(newData("abc"), data);
        }

        Assert.equals(0, buffer.logicalLength);
    }

    @Ignored
    function testShiftBounds() {
        var data1 = newData("hello");
        var buffer = newCircularBuffer(6);

        buffer.pushRange(data1);

        var shiftedData = buffer.shiftRange(9999);
        assertDataEqual(shiftedData, data1);
    }

    @Ignored
    function testShiftEmpty() {
        var buffer = newCircularBuffer(6);
        var shiftedData = buffer.shiftRange();
        Assert.equals(0, getDataLength(shiftedData));

        Assert.raises(function () {
            buffer.shift();
        }, BoundsException);
    }

    @Ignored
    function testClear() {
        var data1 = newData("hello");
        var buffer = newCircularBuffer(6);

        buffer.pushRange(data1);

        var shiftedData = buffer.shiftRange(5);
        assertDataEqual(shiftedData, data1);

        buffer.clear();

        shiftedData = buffer.shiftRange();
        Assert.equals(0, getDataLength(shiftedData));
    }

    @Ignored
    function testPeek() {
        var data1 = newData("hello");
        var buffer = newCircularBuffer(6);
        buffer.pushRange(data1);

        var peekedData = buffer.peekRange(2);
        assertDataEqual(peekedData, newData("he"));

        Assert.equals("h".code, buffer.peek());
    }

    @Ignored
    function testPeekEmpty() {
        var buffer = newCircularBuffer(6);

        var peekedData = buffer.peekRange(2);
        Assert.equals(0, getDataLength(peekedData));

        Assert.raises(function () {
            buffer.peek();
        }, BoundsException);
    }
}
