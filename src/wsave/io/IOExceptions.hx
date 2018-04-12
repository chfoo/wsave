package wsave.io;

import haxe.io.Bytes;
import wsave.Exception;


class StreamException extends SystemException {
}


class EndOfFile extends StreamException {
}


class IncompleteRead extends EndOfFile {
    public var data:Bytes;

    public function new (message:String = '', previous:Exception = null, data:Bytes) {
        super(message, previous);
        this.data = data;
    }
}


class BufferFull extends StreamException {
}
