package wsaveapp.server;

import callnest.VoidReturn;
import callnest.Task;
import callnest.TaskTools;
import haxe.ds.Option;
import haxe.io.Bytes;
import plumekit.eventloop.ConnectionServer;
import plumekit.net.Connection;
import plumekit.stream.StreamException.EndOfFileException;
import plumekit.stream.StreamReader;
import plumekit.stream.StreamWriter;
import wsave.logging.Level;
import wsave.logging.Logging;


class EchoServer extends ConnectionServer {
    static var logger = Logging.getLogger(Type.getClassName(EchoServer));

    public function new() {
        super(echoHandler);
        //logger.info("bind", [ "host" => host, "port" => port ]);
    }

    function echoHandler(connection:Connection):Task<VoidReturn> {
        var session = new EchoSession(connection);
        return session.process();
    }
}


class EchoSession {
    static var logger = Logging.getLogger(Type.getClassName(EchoSession));

    var reader:StreamReader;
    var writer:StreamWriter;

    public function new(connection:Connection) {
        this.reader = new StreamReader(connection.source);
        this.writer = new StreamWriter(connection.sink);

        var peerInfo = connection.peerAddress();
        logger.debug("accept",
            [ "host" => peerInfo.hostname, "port" => peerInfo.port]);
    }

    public function process():Task<VoidReturn> {
        return readIteration();
    }

    function readIteration():Task<VoidReturn> {
        logger.debug("read_line");

        return reader.readOnce().continueWith(readIterationCallback);
    }

    function readIterationCallback(task:Task<Option<Bytes>>):Task<VoidReturn> {
        switch (task.getResult()) {
            case Some(bytes):
                logger.verbose("line", [ "line" => bytes ]);
                return writer.write(bytes).continueWith(writeCallback);
            case None:
                return TaskTools.fromResult(Nothing);
        }
    }

    function writeCallback(task:Task<Int>):Task<VoidReturn> {
        try {
            task.getResult();
        } catch (exception:EndOfFileException) {
            return TaskTools.fromResult(Nothing);
        }

        return readIteration();
    }
}
