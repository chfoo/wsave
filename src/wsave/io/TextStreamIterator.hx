package wsave.io;

import wsave.io.IOExceptions;


class TextStreamIterator {
    var source:TextReader;
    var destination:TextWriter;
    var nextLine:String;

    public function new(source:TextReader, ?destination:TextWriter) {
        this.source = source;
        this.destination = destination;
    }

    public function hasNext():Bool {
        bufferNextLine();

        return nextLine != null;
    }

    public function next():String {
        bufferNextLine();

        var line = nextLine;

        if (destination != null) {
            destination.write(line);
        }

        nextLine = null;
        return line;
    }

    function bufferNextLine() {
        if (nextLine == null) {
            try {
                nextLine = source.readLine(true);
            } catch (exception:IncompleteTextRead) {
                nextLine = exception.data;
            } catch (exception:EndOfFile) {
                nextLine = null;
            }
        }
    }

    public function iterator() {
        return this;
    }
}
