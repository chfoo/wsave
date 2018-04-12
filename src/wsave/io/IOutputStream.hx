package wsave.io;

import haxe.io.Bytes;


interface IOutputStream {
    public function write(data:Bytes):Void;
    public function flush():Void;
    public function close():Void;
}
