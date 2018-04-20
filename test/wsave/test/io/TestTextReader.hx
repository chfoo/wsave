package wsave.test.io;

import haxe.io.Bytes;
import haxe.io.BytesInput;
import utest.Assert;
import wsave.io.IOExceptions;
import wsave.io.StreamReader;
import wsave.io.TextReader;


class TestTextReader {
    public function new() {
    }

    public function testReadAll() {
        var inputData = Bytes.ofString("Hello world!");
        var input = new BytesInput(inputData);
        var streamReader = new StreamReader(input);
        streamReader.chunkSize = 3;
        var textReader = new TextReader(streamReader);

        var readData = textReader.read();
        Assert.equals("Hello world!", readData);
    }

    public function testReadAmount() {
        var inputData = Bytes.ofString("Hello world!");
        var input = new BytesInput(inputData);
        var streamReader = new StreamReader(input);
        streamReader.chunkSize = 3;
        var expectedStringBuffer = new StringBuf();
        var textReader = new TextReader(streamReader);

        while (expectedStringBuffer.length < 5) {
            var readData = textReader.read(5 - expectedStringBuffer.length);
            expectedStringBuffer.add(readData);
        }
        var readData = expectedStringBuffer.toString();

        Assert.equals("Hello", readData);
    }

    public function testReadLine() {
        var inputData = Bytes.ofString(
            "Cat\nDog\r\nBird\rFish\n" +
            "Cat\nDog\r\nBird\rFish\n");
        var input = new BytesInput(inputData);
        var streamReader = new StreamReader(input);
        streamReader.chunkSize = 3;
        var textReader = new TextReader(streamReader);
        var lines = [];

        for (index in 0...8) {
            lines.push(textReader.readLine(index < 4));
        }

        Assert.equals("Cat\n", lines[0]);
        Assert.equals("Dog\r\n", lines[1]);
        Assert.equals("Bird\r", lines[2]);
        Assert.equals("Fish\n", lines[3]);
        Assert.equals("Cat", lines[4]);
        Assert.equals("Dog", lines[5]);
        Assert.equals("Bird", lines[6]);
        Assert.equals("Fish", lines[7]);
    }

    public function testReadLineEndOfFile() {
        var inputData = Bytes.ofString("Cat\n");
        var input = new BytesInput(inputData);
        var streamReader = new StreamReader(input);
        var textReader = new TextReader(streamReader);

        streamReader.chunkSize = 3;
        textReader.readLine();
        Assert.raises(function () { textReader.readLine();}, EndOfFile);
    }

    public function testReadLineIncomplete() {
        var inputData = Bytes.ofString("Cat\nSomething");
        var input = new BytesInput(inputData);
        var streamReader = new StreamReader(input);
        var textReader = new TextReader(streamReader);

        streamReader.chunkSize = 3;
        textReader.readLine();
        Assert.raises(function () { textReader.readLine(); }, IncompleteTextRead);
    }

    public function testReadUntil() {
        var inputData = Bytes.ofString("Cat\nDog\nHorse\nBird\n");
        var input = new BytesInput(inputData);
        var streamReader = new StreamReader(input);
        streamReader.chunkSize = 3;
        var textReader = new TextReader(streamReader);
        var lines = [];

        for (index in 0...4) {
            var keepEnd = index % 2 == 0;
            lines.push(textReader.readUntil(keepEnd));
        }

        Assert.equals("Cat\n", lines[0]);
        Assert.equals("Dog", lines[1]);
        Assert.equals("Horse\n", lines[2]);
        Assert.equals("Bird", lines[3]);
    }

    public function testReadUntilEndOfFile() {
        var inputData = Bytes.ofString("Cat\n");
        var input = new BytesInput(inputData);
        var streamReader = new StreamReader(input);
        var textReader = new TextReader(streamReader);

        streamReader.chunkSize = 3;
        textReader.readUntil();
        Assert.raises(function () { textReader.readUntil(); }, EndOfFile);
    }

    public function testReadUntilIncomplete() {
        var inputData = Bytes.ofString("Cat\nSomething");
        var input = new BytesInput(inputData);
        var streamReader = new StreamReader(input);
        var textReader = new TextReader(streamReader);

        streamReader.chunkSize = 3;
        textReader.readUntil();
        Assert.raises(function () { textReader.readUntil(); }, IncompleteTextRead);
    }

    public function testEndOfFile() {
        var inputData = Bytes.ofString("Hello world!");
        var input = new BytesInput(inputData);
        var streamReader = new StreamReader(input);
        streamReader.chunkSize = 3;
        var textReader = new TextReader(streamReader);

        textReader.read(12);
        Assert.raises(function () { streamReader.read(); }, EndOfFile);
        Assert.raises(function () { streamReader.read(1); }, EndOfFile);
    }
}
