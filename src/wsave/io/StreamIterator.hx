package wsave.io;

import haxe.io.Bytes;
import wsave.io.IOExceptions;


class StreamIterator {
    public var chunkSize = 8192;

    var source:IInputStream;
    var destination:IOutputStream;
    var nextChunk:Bytes;

    public function new(source:IInputStream, ?destination:IOutputStream) {
        this.source = source;
        this.destination = destination;
    }

    public function iterator() {
        return this;
    }

    public function hasNext():Bool {
        fillBuffer();

        return nextChunk != null;
    }

    public function next():Bytes {
        fillBuffer();

        var data = nextChunk;

        if (destination != null) {
            destination.write(data);
        }

        nextChunk = null;
        return data;
    }

    function fillBuffer() {
        if (nextChunk != null) {
            return;
        }

        try {
            nextChunk = source.read(chunkSize);
        } catch (exception:IncompleteRead) {
            nextChunk = exception.data;
        } catch (exception:EndOfFile) {
            nextChunk = null;
        }
    }
}
