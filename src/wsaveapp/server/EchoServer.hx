package wsaveapp.server;

import wsave.io.IOExceptions;
import wsave.io.StreamReader;
import wsave.io.StreamWriter;
import wsave.logging.Level;
import wsave.logging.Logging;
import wsave.sys.net.StreamServer;


class EchoServer extends StreamServer {
    static var logger = Logging.getLogger(Type.getClassName(EchoServer));

    var reader:StreamReader;
    var writer:StreamWriter;

    public function new(host:String, port:Int) {
        super(host, port, echoHandler);

        logger.info("bind", [ "host" => host, "port" => port ]);
    }

    function echoHandler(reader:StreamReader, writer:StreamWriter) {
        this.reader = reader;
        this.writer = writer;

        logger.debug("accept");

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

        writer.write(line);
        writer.flush();

        return true;
    }
}
