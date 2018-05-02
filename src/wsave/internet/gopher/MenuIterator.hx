package wsave.internet.gopher;

import wsave.io.IOExceptions;


class MenuIterator {
    var protocol:ProtocolReaderWriter;
    var nextDirectory:DirectoryEntity;

    public function new(protocol:ProtocolReaderWriter) {
        this.protocol = protocol;
    }

    public function iterator():MenuIterator {
        return this;
    }

    public function hasNext():Bool {
        bufferNext();

        return nextDirectory != null;
    }

    public function next():DirectoryEntity {
        bufferNext();

        var directoryEntity = nextDirectory;
        nextDirectory = null;

        return directoryEntity;
    }

    function bufferNext() {
        if (nextDirectory != null) {
            return;
        }

        try {
            nextDirectory = protocol.readDirectoryEntity();
        } catch (exception:EndOfFile) {
        }
    }
}
