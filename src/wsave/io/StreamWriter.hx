package wsave.io;

import haxe.io.Bytes;
import haxe.io.Output;


class StreamWriter implements IOutputStream {
    var output:Output;

    public function new(output:Output) {
        this.output = output;
    }

    public function write(data:Bytes) {
        output.write(data);
    }

    public function flush() {
        output.flush();
    }

    public function close() {
        output.close();
    }
}
