package wsave.io;

import wsave.text.codec.Encoder;
import wsave.text.codec.ErrorMode;
import wsave.text.codec.Registry;

class TextWriter {
    var outputStream:IOutputStream;
    var encoder:Encoder;

    public function new(outputStream:IOutputStream, encoding:String = "utf-8", ?errorMode:ErrorMode) {
        this.outputStream = outputStream;
        encoder = Registry.getEncoder(encoding, errorMode);
    }

    public function write(text:String) {
        outputStream.write(encoder.encode(text));
    }

    public function flush() {
        outputStream.flush();
    }

    public function close() {
        outputStream.close();
    }
}
