package wsave.test.internet.gopher;

import haxe.io.Bytes;
import haxe.io.BytesInput;
import utest.Assert;
import wsave.io.StreamReader;
import wsave.io.TextReader;
import wsave.internet.gopher.TextFileReadIterator;


class TestTextFileReadIterator {

    public function new() {
    }

    public function testReader() {
        var bytes = new BytesInput(Bytes.ofString(SampleText.ENCODED_TEXT_1));
        var source = new TextReader(new StreamReader(bytes));
        var reader = new TextFileReadIterator(source);
        var outputBuffer = new StringBuf();

        for (line in reader) {
            outputBuffer.add(line);
        }

        var output = outputBuffer.toString();
        Assert.equals(SampleText.TEXT_1, output);
    }
}
