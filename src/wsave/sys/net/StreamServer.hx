package wsave.sys.net;

import sys.net.Socket;
import wsave.io.StreamReader;
import wsave.io.StreamWriter;


typedef StreamHandler = StreamReader->StreamWriter->Void;


class StreamServer extends SocketServer {
    var streamHandler:StreamHandler;

    public function new(host:String, port:Int, handler:StreamHandler) {
        this.streamHandler = handler;
        super(host, port, socketHandler);
    }

    function socketHandler(socket:Socket) {
        streamHandler(
            new StreamReader(socket.input),
            new StreamWriter(socket.output)
        );
    }
}
