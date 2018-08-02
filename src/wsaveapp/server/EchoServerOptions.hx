package wsaveapp.server;

import tink.cli.Rest;


class EchoServerOptions {
    @:flag("--help")
    public var help:Bool;

    @:flag("--host")
    @:alias("s")
    public var host:String = "localhost";

    @:flag("--port")
    public var port:Int = 8010;

    public function new() {
    }

    @:defaultCommand
    public function run(rest:Rest<String>) {
        if (help) {
            ArgParserTools.showHelp(this);
            return;
        }

        var server = new EchoServer();
        var serverTask = server.start(host, port);
        Runner.runAsync(serverTask);
    }
}
