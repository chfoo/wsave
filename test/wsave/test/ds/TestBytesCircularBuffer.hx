package wsave.test.ds;

import haxe.io.Bytes;
import utest.Assert;
import wsave.ds.BaseCircularBuffer;
import wsave.ds.BytesCircularBuffer;


class TestBytesCircularBuffer extends BaseTestCircularBuffer<Int,Bytes> {
    override function newCircularBuffer(size:Int):BaseCircularBuffer<Int,Bytes> {
        return new BytesCircularBuffer(size);
    }

    override function newData(text:String):Bytes {
        var data = Bytes.alloc(text.length);

        for (index in 0...text.length) {
            data.set(index, text.charCodeAt(index));
        }

        return data;
    }

    override function getDataLength(data:Bytes):Int {
        return data.length;
    }

    override function assertDataEqual(data1:Bytes, data2:Bytes) {
        Assert.equals(data1.length, data2.length);

        for (index in 0...data1.length) {
            Assert.equals(data1.get(index), data2.get(index));
        }
    }
}
