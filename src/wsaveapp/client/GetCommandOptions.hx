package wsaveapp.client;

import tink.cli.Rest;


/**
    File downloader.
**/
class GetCommandOptions {
    @:flag("--help")
    public var help:Bool;

    public function new() {
    }

    /**
        <SOURCE> <DEST>
        Download URL "SOURCE" to file "DEST".
    **/
    @:defaultCommand
    public function run(rest:Rest<String>) {
        if (help) {
            ArgParserTools.showHelp(this);
            return;
        }

        var common = new GetPutCommandCommon(rest);
        Runner.run(common.processGet);
    }
}
