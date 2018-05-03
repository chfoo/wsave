package wsaveapp.server;

import sys.FileSystem;
import sys.io.File;
import wsave.internet.gopher.DirectoryEntity;
import wsave.internet.gopher.ItemType;
import wsave.internet.gopher.ProtocolReaderWriter;
import wsave.io.StreamReader;
import wsave.logging.Level;
import wsave.logging.Logging;
import wsave.sys.net.StreamServer;
import wsave.sys.PathSandbox;


private typedef LocalAddress = {
    host:String, port:Int
};


class GopherFileServer extends StreamServer {
    static var logger = Logging.getLogger(Type.getClassName(GopherFileServer));

    var pathSandbox:PathSandbox;
    var localAddress:LocalAddress;

    public function new(host:String, port:Int = 70, rootPath:String) {
        super(host, port, gopherHandler);

        pathSandbox = new PathSandbox(rootPath);
        localAddress = { host: host, port: port };

        logger.info("bind", [ "host" => host, "port" => port,
            "path" => pathSandbox.rootPath.toString() ]);
    }

    function gopherHandler(connection:StreamConnection) {
        var session = new GopherFileSession(connection, pathSandbox,
            localAddress);
        session.process();
    }
}


class GopherFileSession {
    static var logger = Logging.getLogger(Type.getClassName(GopherFileSession));

    var protocol:ProtocolReaderWriter;
    var pathSandbox:PathSandbox;
    var localAddress:LocalAddress;

    public function new(connection:StreamConnection, pathSandbox:PathSandbox,
            localAddress:LocalAddress) {
        this.protocol = new ProtocolReaderWriter(
            connection.reader, connection.writer);
        this.pathSandbox = pathSandbox;
        this.localAddress = localAddress;

        var peerInfo = connection.socket.peer();
        logger.debug("accept",
            [ "host" => peerInfo.host.ip, "port" => peerInfo.port]);
    }

    public function process() {
        try {
            serve();
        } catch (exception:Dynamic) {
            logger.exception(Level.Error, "serve_error", exception);
        }

        protocol.close();
    }

    function serve() {
        var selector = protocol.readSelector();
        logger.debug("selector", [ "selector" => selector ]);

        var fileInfo = pathSandbox.getFile(selector);

        if (fileInfo != null) {
            writeFile(fileInfo);

            return;
        }

        var dirListing = pathSandbox.getDirectoryListing(selector);

        if (dirListing != null) {
            writeMenu(dirListing);
        }
    }

    function writeFile(fileInfo:UserPathInfo) {
        var path = fileInfo.systemPath.toString();

        logger.debug("serve_file", [ "path" => path ]);

        var file = File.read(path);

        try {
            for (chunk in protocol.writeBinaryFile(new StreamReader(file))) {
            }
        } catch (exception:Dynamic) {
            file.close();
            throw exception;
        }
    }

    function writeMenu(dirListing:Array<UserPathInfo>) {
        for (info in dirListing) {
            var type;

            if (FileSystem.isDirectory(info.systemPath.toString())) {
                type = ItemType.Menu;
            } else {
                type = ItemType.BinaryFile;
            }

            var entity = new DirectoryEntity(
                type,
                info.userPath,
                info.userPath,
                localAddress.host,
                localAddress.port
            );

            protocol.writeDirectoryEntity(entity);
        }
    }
}
