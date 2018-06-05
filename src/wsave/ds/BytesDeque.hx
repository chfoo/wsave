package wsave.ds;

import commonbox.ds.Deque;
import haxe.io.Bytes;

using commonbox.utils.OptionTools;


class BytesDeque extends Deque<Int> {
    public function shiftBytes(?count:Int):Bytes {
        count = normalizeIndexCount(count);
        var bytes = Bytes.alloc(count);

        for (index in 0...count) {
            bytes.set(index, shift().getSome());
        }

        return bytes;
    }

    public function peekBytes(?count:Int) {
        count = normalizeIndexCount(count);
        var bytes = Bytes.alloc(count);

        for (index in 0...count) {
            bytes.set(index, get(index));
        }

        return bytes;
    }

    public function pushBytes(data:Bytes, position:Int = 0, ?length:Int) {
        if (length == null) {
            length = data.length - position;
        }

        for (index in position...length) {
            push(data.get(index));
        }
    }

    function normalizeIndexCount(?count:Int):Int {
        if (count == null) {
            return this.length;
        } else {
            return Std.int(Math.min(count, this.length));
        }
    }
}
