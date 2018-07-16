package wsaveapp.server;

import tink.cli.Rest;


class GopherFileServerOptions {
    @:flag("--help")
    public var help:Bool;

    @:flag("--host")
    @:alias("s")
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
        if (help) {
            ArgParserTools.showHelp(this);
            return;
        }

        var server = new GopherFileServer(path);
        var serverTask = server.start(host, port);
        Runner.run(serverTask);
    }
}
