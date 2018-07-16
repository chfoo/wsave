package wsaveapp;

import tink.core.Error;
import wsaveapp.server.EchoServerOptions;
import wsaveapp.server.GopherFileServerOptions;


class Options {
    public function new() {
        serveEcho = new EchoServerOptions();
        serveGopher = new GopherFileServerOptions();
    }

    @:defaultCommand
    public function run() {
        ArgParserTools.showHelp(this);
    }

    @:command("serve-echo")
    public var serveEcho:EchoServerOptions;

    @:command("serve-gopher")
    public var serveGopher:GopherFileServerOptions;
}


class ShowHelp extends Error {
    public var command(default, null):Dynamic;

    public function new(command:Dynamic) {
        this.command = command;
        super("shouldn't see this");
    }
}
