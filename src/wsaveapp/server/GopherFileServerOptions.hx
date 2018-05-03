package wsaveapp.server;

import tink.cli.Rest;


class GopherFileServerOptions {
    @:flag("--host")
    public var host:String = "localhost";

    @:flag("--port")
    public var port:Int = 7070;

    @:flag("--path")
    @:alias(false)
    public var path:String = "./";

    public function new() {
    }

    @:defaultCommand
    public function run(rest:Rest<String>) {
        var server = new GopherFileServer(host, port, path);
        server.run();
    }
}
