package wsave.crash;

import haxe.CallStack;
import sys.io.File;
import sys.FileSystem;
import haxe.ds.Option;


class ExceptionHandler {
    public static function run(func:Void->Void):Option<DiagnosticInfo> {
        var startTimestamp = Sys.time();
        try {
            func();
        } catch (exception:Any) {
            return Some(new DiagnosticInfo(exception, startTimestamp));
        }

        return None;
    }

    public static function getHelpMessage(info:DiagnosticInfo, reportFilename:String):String {
        var template = new haxe.Template(
            "Oops! An error occurred and the program will now stop.\n\n"
            + "Error: ::errorSummary::\n"
            + "A file containing additional information is located at ::reportFilename::. Please include this file when reporting this error.\n");

        return template.execute({
           errorSummary: info.getSummary(),
           reportFilename: reportFilename
        });
    }

    public static function writeReport(info:DiagnosticInfo):String {
        var time = Std.int(Sys.time());
        var randomSeq = Std.random(0x7fff) << 16 | Std.random(0xffff);
        var filename = 'wsave-error-${time}-$randomSeq.txt';
        var path = FileSystem.absolutePath(filename);

        File.saveContent(path, ReportFormatter.format(info));

        return path;
    }
}
