package wsave.test.io;

import haxe.io.Bytes;
import haxe.io.BytesInput;
import haxe.io.BytesOutput;
import utest.Assert;
import wsave.io.StreamReader;
import wsave.io.StreamWriter;
import wsave.io.TextReader;
import wsave.io.TextStreamIterator;
import wsave.io.TextWriter;

using StringTools;


class TestTextStreamIterator {
    public function new() {
    }

    public function testStreamIterator() {
        var data = Bytes.ofString(getLongString());
        var destBuffer = new BytesOutput();
        var source = new TextReader(new StreamReader(new BytesInput(data)));
        var destination = new TextWriter(new StreamWriter(destBuffer));

        var iterator = new TextStreamIterator(source, destination);

        for (line in iterator) {
            Assert.isTrue(line.startsWith("Hello world!"));
        }

        var destData = destBuffer.getBytes();

        Assert.equals(0, data.compare(destData));
    }

    function getLongString():String {
        var buffer = new StringBuf();

        for (dummy in 0...1000) {
            buffer.add("Hello world! 1\r\n");
            buffer.add("Hello world! 2\r");
            buffer.add("Hello world! 3\n");
        }

        buffer.add("Hello world! 4");

        return buffer.toString();
    }
}
