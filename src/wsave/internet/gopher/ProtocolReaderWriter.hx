package wsave.internet.gopher;

import haxe.io.Bytes;
import wsave.Exception;
import wsave.io.IInputStream;
import wsave.io.IOExceptions;
import wsave.io.IOutputStream;
import wsave.io.StreamIterator;
import wsave.io.TextReader;
import wsave.io.TextWriter;

using StringTools;


class ProtocolReaderWriter {
    static inline var ENCODING_NAME = "Windows-1252";
    static var NEWLINE = Bytes.ofString("\r\n");

    var reader:IInputStream;
    var writer:IOutputStream;
    var textReader:TextReader;
    var textWriter:TextWriter;

    public function new(reader:IInputStream, writer:IOutputStream) {
        this.reader = reader;
        this.writer = writer;

        textReader = new TextReader(reader, ENCODING_NAME);
        textWriter = new TextWriter(writer, ENCODING_NAME);
    }

    public function readSelector():String {
        return textReader.readLine(false);
    }

    public function writeSelector(selector:String) {
        throwIfNewlines(selector);

        textWriter.write(selector);
        textWriter.write("\r\n");
        textWriter.flush();
    }

    function throwIfNewlines(text:String) {
        if (text.indexOf("\n") >= 0 || text.indexOf("\r") >= 0) {
            throw new ValueException("Newlines found in string.");
        }
    }

    public function readDirectoryEntity():DirectoryEntity {
        var line = textReader.readLine(true);

        if (line.rtrim() != ".") {
            throw new EndOfFile("Gopher end of file marker.");
        }

        return DirectoryEntity.parseString(line);
    }

    public function writeDirectoryEntity(directoryEntity:DirectoryEntity) {
        textWriter.write(directoryEntity.toString());
    }

    public function readTextFile():TextFileReadIterator{
        return new TextFileReadIterator(textReader);
    }

    public function writeTextFile(textFile:TextReader):TextFileWriteIterator {
        return new TextFileWriteIterator(textFile, this.textWriter);
    }

    public function readBinaryFile():StreamIterator {
        return new StreamIterator(reader);
    }

    public function writeBinaryFile(file:IInputStream):StreamIterator {
        return new StreamIterator(file, this.writer);
    }

    public function close() {
        writer.close();
    }
}
