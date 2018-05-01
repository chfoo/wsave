package wsaveapp;

import wsaveapp.server.EchoServer;
import tink.cli.Rest;


class Options {
    public function new() {
        serveEcho = new EchoServerOptions();
    }

    @:defaultCommand
    public function run() {

    }

    @:command("serve-echo")
    public var serveEcho:EchoServerOptions;
}


class ServerOptions {
    @:flag("--host")
    public var host:String = "localhost";

    @:flag("--port")
    public var port:Int = 8010;

    public function new() {
    }
}


class EchoServerOptions extends ServerOptions {
    @:defaultCommand
    public function run(rest:Rest<String>) {
        var server = new EchoServer(host, port);
        server.run();
    }
}
