package wsave.crash;

import haxe.CallStack;


class ReportFormatter {
    public static function format(info:DiagnosticInfo):String {
        var buffer = new StringBuf();

        buffer.add("# Wsave error report\n\n");
        buffer.add("Timestamp: ");
        buffer.add(Std.string(info.currentTimestamp));
        buffer.add("\n");
        buffer.add("Start timestamp: ");
        buffer.add(Std.string(info.currentTimestamp));
        buffer.add("\n");
        buffer.add("Version: ");
        buffer.add(info.version);
        buffer.add("\n");
        buffer.add("Platform: ");
        buffer.add(info.platform);
        buffer.add("\n");
        buffer.add("Build date: ");
        buffer.add(info.buildDate);
        buffer.add("\n");
        buffer.add("Build hash: ");
        buffer.add(info.buildHash);
        buffer.add("\n");
        buffer.add("Program: ");
        buffer.add(info.programName);
        buffer.add("\n");
        buffer.add("Program args: ");
        buffer.add(info.programArgs.join(" "));
        buffer.add("\n");
        buffer.add("Exception: ");
        buffer.add(Std.string(info.exception));
        buffer.add("\n");
        buffer.add("Call stack: ");
        buffer.add(CallStack.toString(info.callStack));
        buffer.add("\n");
        buffer.add("# end of report\n");

        return buffer.toString();
    }
}
