package wsaveapp.server;

import haxe.io.Error;
import wsave.io.IOExceptions;
import wsave.io.StreamReader;
import wsave.io.StreamWriter;
import wsave.logging.Level;
import wsave.logging.Logging;
import wsave.sys.net.StreamServer;


class EchoServer extends StreamServer {
    static var logger = Logging.getLogger(Type.getClassName(EchoServer));

    public function new(host:String, port:Int) {
        super(host, port, echoHandler);

        logger.info("bind", [ "host" => host, "port" => port ]);
    }

    function echoHandler(connection:StreamConnection) {
        var session = new EchoSession(connection);
        session.process();
    }
}


class EchoSession {
    static var logger = Logging.getLogger(Type.getClassName(EchoSession));

    var reader:StreamReader;
    var writer:StreamWriter;

    public function new(connection:StreamConnection) {
        this.reader = connection.reader;
        this.writer = connection.writer;

        var peerInfo = connection.socket.peer();
        logger.debug("accept",
            [ "host" => peerInfo.host.ip, "port" => peerInfo.port]);
    }

    public function process() {
        while (true) {
            var success;
            try {
                success = processLine();
            } catch (exception:Dynamic) {
                logger.exception(Level.Error, "line_error", exception);
                throw exception;
            }

            if (!success) {
                break;
            }
        }

        logger.debug("close");
        writer.close();
    }

    function processLine():Bool {
        var line;

        try {
            logger.debug("read_line");
            line = reader.readUntil(true);
        } catch (exception:EndOfFile) {
            return false;
        }

        logger.verbose("line", [ "line" => line ]);

        try {
            writer.write(line);
            writer.flush();
        } catch (exception:Error) {
            logger.exception(Level.Debug, "write_error", exception);
            return false;
        }

        return true;
    }
}
