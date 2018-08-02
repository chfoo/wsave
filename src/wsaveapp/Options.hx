package wsaveapp;

import tink.core.Error;
import wsaveapp.client.GetCommandOptions;
import wsaveapp.client.PutCommandOptions;
import wsaveapp.server.EchoServerOptions;
import wsaveapp.server.GopherFileServerOptions;


/**
    Wsave
**/
class Options {
    public function new() {
        getCommand = new GetCommandOptions();
        putCommand = new PutCommandOptions();
        serveEcho = new EchoServerOptions();
        serveGopher = new GopherFileServerOptions();
    }

    /**
        <command>
    **/
    @:defaultCommand
    public function run() {
        ArgParserTools.showHelp(this);
    }

    @:command("get")
    public var getCommand:GetCommandOptions;

    @:command("put")
    public var putCommand:PutCommandOptions;

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
