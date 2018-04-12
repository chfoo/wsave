package wsave.io;

import haxe.io.Bytes;


interface IInputStream {
    public function read(amount:Int = -1, exact:Bool = false):Bytes;
    public function readLine(keepEnd:Bool = false):Bytes;
    public function readUntil(separator:Int = "\n".code, keepEnd:Bool = false):Bytes;
}
