package wsave.test.io;

import haxe.io.Bytes;
import haxe.io.BytesInput;
import haxe.io.BytesOutput;
import utest.Assert;
import wsave.io.StreamIterator;
import wsave.io.StreamReader;
import wsave.io.StreamWriter;


class TestStreamIterator {
    public function new() {
    }

    public function testStreamIterator() {
        var data = Bytes.ofString(getLongString());
        var destBuffer = new BytesOutput();
        var source = new StreamReader(new BytesInput(data));
        var destination = new StreamWriter(destBuffer);

        var iterator = new StreamIterator(source, destination);
        iterator.chunkSize = 10;

        for (chunk in iterator) {
            Assert.isTrue(chunk.length > 0);
            Assert.isTrue(chunk.length <= 10);
        }

        var destData = destBuffer.getBytes();

        Assert.equals(0, data.compare(destData));
    }

    function getLongString():String {
        var buffer = new StringBuf();

        for (dummy in 0...1000) {
            buffer.add("Hello world!");
        }

        return buffer.toString();
    }
}
