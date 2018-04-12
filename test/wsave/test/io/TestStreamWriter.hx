package wsave.test.io;

import haxe.io.Bytes;
import haxe.io.BytesOutput;
import utest.Assert;
import wsave.io.StreamWriter;


class TestStreamWriter {
    public function new() {
    }

    public function testMemoryWrite() {
        var output = new BytesOutput();
        var streamWriter = new StreamWriter(output);

        streamWriter.write(Bytes.ofString("Hello world!"));
        streamWriter.flush();
        streamWriter.close();

        var data = output.getBytes();

        Assert.equals(0, data.compare(Bytes.ofString("Hello world!")));
    }
}
