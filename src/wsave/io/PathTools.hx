package wsave.io;

import haxe.io.Path;

using StringTools;


class PathTools {
    public static function containsPath(rootPath:Path, otherPath:Path):Bool {
        var rootDir = Path.addTrailingSlash(rootPath.dir);
        var otherDir = Path.addTrailingSlash(otherPath.dir);

        return otherDir.startsWith(rootDir);
    }

    public static function trimPath(targetPath:Path, startPath:Path):Path {
        var startDir = Path.addTrailingSlash(startPath.dir);
        var targetDir = Path.addTrailingSlash(targetPath.dir);

        if (targetDir.indexOf(startDir) != 0) {
            return targetPath;
        }

        var replacement = targetPath.dir.startsWith("/") ? "/" : "";

        return new Path(targetPath.toString().replace(startDir, replacement));
    }
}
