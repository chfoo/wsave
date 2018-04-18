package wsave.test.ds;

import haxe.ds.Vector;
import utest.Assert;
import wsave.ds.BaseCircularBuffer;
import wsave.ds.CircularBuffer;


class TestCircularBuffer extends BaseTestCircularBuffer<Int,Vector<Int>> {
    override function newCircularBuffer(size:Int):BaseCircularBuffer<Int,Vector<Int>> {
        return new CircularBuffer<Int>(size);
    }

    override function newData(text:String):Vector<Int> {
        var data = new Vector<Int>(text.length);

        for (index in 0...text.length) {
            data.set(index, text.charCodeAt(index));
        }

        return data;
    }

    override function newItem(value:Int):Int {
        return value;
    }

    override function getDataLength(data:Vector<Int>):Int {
        return data.length;
    }

    override function assertDataEqual(data1:Vector<Int>, data2:Vector<Int>) {
        Assert.equals(data1.length, data2.length);

        for (index in 0...data1.length) {
            Assert.equals(data1.get(index), data2.get(index));
        }
    }

    override public function testPushShift() {
        super.testPushShift();
    }

    override public function testResize() {
        super.testResize();
    }

    override public function testShiftBounds() {
        super.testShiftBounds();
    }

    override public function testShiftEmpty() {
        super.testShiftEmpty();
    }

    override public function testClear() {
        super.testClear();
    }

    override public function testPeek() {
        super.testPeek();
    }
}
