package wsave.test.internet.gopher;

import haxe.io.Bytes;
import haxe.io.BytesInput;
import haxe.io.BytesOutput;
import utest.Assert;
import wsave.io.StreamReader;
import wsave.io.StreamWriter;
import wsave.io.TextReader;
import wsave.io.TextWriter;
import wsave.internet.gopher.TextFileWriteIterator;


class TestTextFileWriteIterator {
    public function new() {
    }

    public function testWriter() {
        var sourceBytes = new BytesInput(Bytes.ofString(SampleText.TEXT_1));
        var source = new TextReader(new StreamReader(sourceBytes));
        var destBytes = new BytesOutput();
        var destination = new TextWriter(new StreamWriter(destBytes));
        var writer = new TextFileWriteIterator(source, destination);

        for (line in writer) {
        }

        var output = destBytes.getBytes().toString();

        Assert.equals(SampleText.ENCODED_TEXT_1, output);
    }
}
