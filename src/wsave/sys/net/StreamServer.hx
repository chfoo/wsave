package wsave.sys.net;

import sys.net.Socket;
import wsave.io.StreamReader;
import wsave.io.StreamWriter;


typedef StreamConnection = {
    reader:StreamReader,
    writer:StreamWriter,
    socket:Socket
};

typedef StreamHandler = StreamConnection->Void;


class StreamServer extends SocketServer {
    var streamHandler:StreamHandler;

    public function new(host:String, port:Int, handler:StreamHandler) {
        this.streamHandler = handler;
        super(host, port, socketHandler);
    }

    function socketHandler(socket:Socket) {
        streamHandler({
            reader: new StreamReader(socket.input),
            writer: new StreamWriter(socket.output),
            socket: socket
        });
    }
}
