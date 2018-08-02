package wsaveapp.client;


import plumekit.Exception.ValueException;
import plumekit.url.URL;
import sys.FileSystem;
import callnest.TaskDefaults;
import callnest.VoidReturn;
import callnest.Task;


class GetPutCommandCommon {
    var args:Array<String>;
    var source:String;
    var dest:String;

    public function new(args:Array<String>) {
        this.args = args;
    }

    public function processGet() {
        validatePositionalArguments();
        extractArgs();
        checkURL(source);

        throw "not implemented";
    }

    public function processPut() {
        validatePositionalArguments();
        extractArgs();
        checkFile(source);
        checkURL(dest);

        throw "not implemented";
    }

    function validatePositionalArguments() {
        if (args.length < 2) {
            ArgParserTools.exitParserError("A source and destination is required.");
        } else if (args.length > 2) {
            ArgParserTools.exitParserError("Only one source is allowed.");
        }
    }

    function extractArgs() {
        source = args[0];
        dest = args[1];
    }

    function checkFile(name:String) {
        if (name == "-") {
            return;
        }

        if (!FileSystem.exists(name) || FileSystem.isDirectory(name)) {
            ArgParserTools.exitParserError('$name is not a readable file.');
        }
    }

    function checkURL(url:String) {
        try {
            new URL(url);
        } catch (exception:ValueException) {
            ArgParserTools.exitParserError("URL is not properly formatted.");
        }
    }
}
