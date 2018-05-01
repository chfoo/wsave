package wsave.sys.net;

import sys.net.Host;
import sys.net.Socket;
import haxe.io.Error;
import haxe.MainLoop;

using haxe.EnumTools;


class SocketServer {
    public var host(default, null):Host;
    public var port(default, null):Int;
    public var socket(default, null):Socket;

    var handler:Socket->Void;
    var running = false;

    public function new(host:String, port:Int, handler:Socket->Void) {
        socket = new Socket();
        socket.bind(new Host(host), port);

        this.host = socket.host().host;
        this.port = socket.host().port;
        this.handler = handler;

        socket.setTimeout(5);
    }

    public function run(connections:Int = 100) {
        running = true;
        socket.listen(connections);

        while (running) {
            var childSocket;
            try {
                childSocket = socket.accept();
            } catch (exception:Error) {
                if (Error.Blocked.equals(exception)) {
                    continue;
                } else {
                    throw exception;
                }
            } catch (exception:String) {
                if (exception == "Blocking") {
                    continue;
                } else {
                    throw exception;
                }
            }

            dispatchSocket(childSocket);
        }
    }

    public function stop() {
        running = false;
        socket.close();
    }

    function dispatchSocket(socket:Socket) {
        Debug.assert(this.socket != socket);
        socket.setTimeout(0);
        socket.setBlocking(true);
        MainLoop.addThread(handler.bind(socket));
    }
}
