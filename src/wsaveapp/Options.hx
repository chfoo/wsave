package wsaveapp;

import wsaveapp.server.EchoServerOptions;
import wsaveapp.server.GopherFileServerOptions;


class Options {
    public function new() {
        serveEcho = new EchoServerOptions();
        serveGopher = new GopherFileServerOptions();
    }

    @:defaultCommand
    public function run() {

    }

    @:command("serve-echo")
    public var serveEcho:EchoServerOptions;

    @:command("serve-gopher")
    public var serveGopher:GopherFileServerOptions;
}
