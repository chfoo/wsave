package wsaveapp.server;

import callnest.Task;
import callnest.VoidReturn;
import haxe.ds.Option;
import plumekit.eventloop.EventLoop;
import plumekit.net.Connection;
import plumekit.net.ConnectionAddress;
import plumekit.stream.InputStream;
import plumekit.protocol.gopher.DirectoryEntity;
import plumekit.protocol.gopher.ItemType;
import plumekit.protocol.gopher.Server;
import plumekit.protocol.gopher.ServerSession;
import sys.FileSystem;
import sys.io.File;
import wsave.logging.Level;
import wsave.logging.Logging;
import wsave.sys.PathSandbox;

using callnest.TaskTools;


class GopherFileServer extends Server {
    static var logger = Logging.getLogger(Type.getClassName(GopherFileServer));

    var pathSandbox:PathSandbox;

    public function new(rootPath:String, ?eventLoop:EventLoop) {
        super(eventLoop);

        pathSandbox = new PathSandbox(rootPath);

        logger.info("init", [ "path" => pathSandbox.rootPath.toString() ]);
    }

    override function newSession(connection:Connection):ServerSession {
        return new GopherFileSession(connection, pathSandbox);
    }
}


class GopherFileSession extends ServerSession {
    static var logger = Logging.getLogger(Type.getClassName(GopherFileSession));

    var pathSandbox:PathSandbox;
    var localAddress:ConnectionAddress;

    public function new(connection:Connection, pathSandbox:PathSandbox) {
        super(connection);
        this.pathSandbox = pathSandbox;
        this.localAddress = connection.hostAddress();

        var peerInfo = connection.peerAddress();
        logger.debug("accept",
            [ "host" => peerInfo.hostname, "port" => peerInfo.port]);
    }

    public override function process():Task<VoidReturn> {
        return protocol.readSelector().continueWith(readSelectorCallback);
    }

    function readSelectorCallback(task:Task<String>):Task<VoidReturn> {
        var selector = task.getResult();

        logger.debug("selector", [ "selector" => selector ]);

        var fileInfo = pathSandbox.getFile(selector);

        if (fileInfo != null) {
            return writeFile(fileInfo);
        }

        var dirListing = pathSandbox.getDirectoryListing(selector);

        if (dirListing != null) {
            return writeMenu(dirListing);
        }

        return TaskTools.fromResult(Nothing);
    }

    function writeFile(fileInfo:UserPathInfo):Task<VoidReturn> {
        var path = fileInfo.systemPath.toString();

        logger.debug("serve_file", [ "path" => path ]);

        var file = File.read(path);
        var source = new InputStream(file);

        return protocol.putFile(source).transferAll().thenResult(Nothing);
    }

    function writeMenu(dirListing:Array<UserPathInfo>):Task<VoidReturn> {
        return writeMenuIteration(dirListing, 0);
    }

    function writeMenuIteration(dirListing:Array<UserPathInfo>, index:Int):Task<VoidReturn> {
        var info = dirListing[index];
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
            localAddress.hostname,
            localAddress.port
        );

        return protocol.writeDirectoryEntity(entity)
            .continueWith(function (task) {
                task.getResult();

                index += 1;

                if (index >= dirListing.length) {
                    return TaskTools.fromResult(Nothing);
                } else {
                    return writeMenuIteration(dirListing, index);
                }
            });
    }
}
