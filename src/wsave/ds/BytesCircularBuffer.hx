package wsave.ds;

import haxe.io.Bytes;


class BytesCircularBuffer extends BaseCircularBuffer<Int,Bytes> {
    override inline function getNewBuffer(size:Int):Bytes {
        return Bytes.alloc(size);
    }

    override inline function getLength(data:Bytes):Int {
        return data.length;
    }

    override inline function dataSet(data:Bytes, index:Int, value:Int) {
        data.set(index, value);
    }

    override inline function dataGet(data:Bytes, index:Int):Int {
        return data.get(index);
    }
}
