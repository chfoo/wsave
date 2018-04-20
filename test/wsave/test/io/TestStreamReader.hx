package wsave.test.io;

import haxe.io.Bytes;
import haxe.io.BytesBuffer;
import haxe.io.BytesInput;
import utest.Assert;
import wsave.io.IOExceptions;
import wsave.io.StreamReader;


class TestStreamReader {
    public function new() {
    }

    public function testReadAll() {
        var inputData = Bytes.ofString("Hello world!");
        var input = new BytesInput(inputData);
        var streamReader = new StreamReader(input);
        streamReader.chunkSize = 3;
        var readData = streamReader.read();
        Assert.equals("Hello world!", readData.toString());
    }

    public function testReadAmount() {
        var inputData = Bytes.ofString("Hello world!");
        var input = new BytesInput(inputData);
        var streamReader = new StreamReader(input);
        streamReader.chunkSize = 3;
        var expectedDataBuffer = new BytesBuffer();

        while (expectedDataBuffer.length < 5) {
            var readData = streamReader.read(5 - expectedDataBuffer.length);
            expectedDataBuffer.add(readData);
        }
        var readData = expectedDataBuffer.getBytes();

        Assert.equals("Hello", readData.toString());
    }

    public function testReadAmountExact() {
        var inputData = Bytes.ofString("Hello world!");
        var input = new BytesInput(inputData);
        var streamReader = new StreamReader(input);
        streamReader.chunkSize = 3;
        var readData = streamReader.read(5, true);

        Assert.equals("Hello", readData.toString());
    }

    public function testReadUntil() {
        var inputData = Bytes.ofString("Cat\nDog\nHorse\nBird\n");
        var input = new BytesInput(inputData);
        var streamReader = new StreamReader(input);
        streamReader.chunkSize = 3;
        var lines = [];

        for (index in 0...4) {
            var keepEnd = index % 2 == 0;
            lines.push(streamReader.readUntil(keepEnd));
        }

        Assert.equals("Cat\n", lines[0].toString());
        Assert.equals("Dog", lines[1].toString());
        Assert.equals("Horse\n", lines[2].toString());
        Assert.equals("Bird", lines[3].toString());
    }

    public function testReadUntilEndOfFile() {
        var inputData = Bytes.ofString("Cat\n");
        var input = new BytesInput(inputData);
        var streamReader = new StreamReader(input);

        streamReader.chunkSize = 3;
        streamReader.readUntil();
        Assert.raises(function () { streamReader.readUntil(); }, EndOfFile);
    }

    public function testReadUntilIncomplete() {
        var inputData = Bytes.ofString("Cat\nSomething");
        var input = new BytesInput(inputData);
        var streamReader = new StreamReader(input);

        streamReader.chunkSize = 3;
        streamReader.readUntil();
        Assert.raises(function () { streamReader.readUntil(); }, IncompleteRead);
    }

    public function testIncompleteRead() {
        var inputData = Bytes.ofString("Hello world!");
        var input = new BytesInput(inputData);
        var streamReader = new StreamReader(input);
        streamReader.chunkSize = 3;
        var readData:Bytes = null;

        function read() {
            try {
                streamReader.read(100, true);
            } catch (exception:IncompleteRead) {
                readData = exception.data;
                throw exception;
            }
        }

        Assert.raises(read, IncompleteRead);
        Assert.equals("Hello world!", readData.toString());
    }

    public function testEndOfFile() {
        var inputData = Bytes.ofString("Hello world!");
        var input = new BytesInput(inputData);
        var streamReader = new StreamReader(input);
        streamReader.chunkSize = 3;

        streamReader.read(12);
        Assert.raises(function () { streamReader.read(); }, EndOfFile);
        Assert.raises(function () { streamReader.read(1); }, EndOfFile);
    }
}
