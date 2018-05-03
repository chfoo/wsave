package wsaveapp.server;

import tink.cli.Rest;


class EchoServerOptions {
    @:flag("--host")
    public var host:String = "localhost";

    @:flag("--port")
    public var port:Int = 8010;

    public function new() {
    }

    @:defaultCommand
    public function run(rest:Rest<String>) {
        var server = new EchoServer(host, port);
        server.run();
    }
}
