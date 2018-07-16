package wsaveapp;

import haxe.MainLoop;
import haxe.EntryPoint;
import plumekit.eventloop.DefaultEventLoop;
import callnest.Task;


class Runner {
    public static function run<T>(task:Task<T>) {
        DefaultEventLoop.instance().start();

        task.onComplete(function (task) {
            DefaultEventLoop.instance().stop();
            task.getResult();
        });
    }
}
