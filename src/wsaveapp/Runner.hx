package wsaveapp;

import wsave.crash.DiagnosticInfo;
import wsave.crash.ExceptionHandler;
import plumekit.eventloop.DefaultEventLoop;
import callnest.Task;


class Runner {
    public static function runAsync<T>(task:Task<T>) {
        DefaultEventLoop.instance().start();

        task.onComplete(function (task) {
            DefaultEventLoop.instance().stop();

            function func() {
                task.getResult();
            }

            switch ExceptionHandler.run(func) {
                case Some(info):
                    switch task.exceptionCallStack {
                        case Some(callStack):
                            info.callStack = callStack;
                        case None:
                    }

                    exitWithReport(info);
                case None:
            }
        });
    }

    public static function run(func:Void->Void) {
        switch ExceptionHandler.run(func) {
            case Some(info):
                exitWithReport(info);
            case None:
        }
    }

    static function exitWithReport(info:DiagnosticInfo) {
        var reportFilename = ExceptionHandler.writeReport(info);
        var helpMessage = ExceptionHandler.getHelpMessage(info, reportFilename);
        Sys.stderr().writeString(helpMessage);
        Sys.exit(1);
    }
}
