package wsave.ds;

import haxe.ds.Vector;


class CircularBuffer<T> extends BaseCircularBuffer<T,Vector<T>> {
    override inline function getNewBuffer(size:Int):Vector<T> {
        return new Vector<T>(size);
    }

    override inline function getLength(data:Vector<T>):Int {
        return data.length;
    }

    override inline function dataSet(data:Vector<T>, index:Int, value:T) {
        data.set(index, value);
    }

    override inline function dataGet(data:Vector<T>, index:Int):T {
        return data.get(index);
    }
}
