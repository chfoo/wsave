package wsaveapp.client;

import tink.cli.Rest;


/**
    File uploader
**/
class PutCommandOptions {
    @:flag("--help")
    public var help:Bool;

    public function new() {
    }

    /**
        <SOURCE> <DEST>
        Upload file "SOURCE" to URL "DEST".
    **/
    @:defaultCommand
    public function run(rest:Rest<String>) {
        if (help) {
            ArgParserTools.showHelp(this);
            return;
        }

        var common = new GetPutCommandCommon(rest);
        Runner.run(common.processPut);
    }
}
