package wsave.sys;

import haxe.io.Path;
import sys.FileSystem;
import wsave.logging.Logging;

using StringTools;
using wsave.io.PathTools;


typedef UserPathInfo = {
    userPath:String,
    systemPath:Path
};


class PathSandbox {
    static var logger = Logging.getLogger(Type.getClassName(PathSandbox));

    public var rootPath(default, null):Path;

    public function new(rootPath:String) {
        this.rootPath = new Path(
            Path.addTrailingSlash(FileSystem.absolutePath(rootPath))
        );

        logger.debug("init", [ "root_path" => this.rootPath.toString() ]);
    }

    public function getDirectoryListing(userPath:String):Null<Array<UserPathInfo>> {
        var info = userPathToSystemPath(userPath);

        if (info == null
                || !FileSystem.isDirectory(info.systemPath.toString())) {
            return null;
        }

        var listing = [];

        for (name in FileSystem.readDirectory(info.systemPath.toString())) {
            var childPathStr = Path.join([info.systemPath.toString(), name]);
            var childSystemPath = new Path(childPathStr);
            var childUserPath = childSystemPath.trimPath(rootPath);

            listing.push({
                systemPath: childSystemPath,
                userPath: childUserPath.toString()
            });
        }

        return listing;
    }

    public function getFile(userPath:String):Null<UserPathInfo> {
        var info = userPathToSystemPath(userPath);

        if (info == null) {
            return null;
        }

        if (!FileSystem.exists(info.systemPath.toString()) ||
                FileSystem.isDirectory(info.systemPath.toString())) {
            return null;
        }

        return info;
    }

    function userPathToSystemPath(userPath:String):Null<UserPathInfo> {
        var systemPath = new Path(joinRootPath(userPath));

        logger.verbose("user_to_system_path",
            [ "system_path" => systemPath.toString() ]);

        if (!rootPath.containsPath(systemPath)) {
            return null;
        }

        var normalizedUserPath = systemPath.trimPath(rootPath);

        return {
            userPath: normalizedUserPath.toString(),
            systemPath: systemPath
        };
    }

    function joinRootPath(userPath:String):String {
        var systemStrPath = FileSystem.absolutePath(
            Path.join([rootPath.toString(), userPath]));

        if (userPath.endsWith("/") || userPath == "") {
            systemStrPath = Path.addTrailingSlash(systemStrPath);
        }

        return systemStrPath;
    }
}
