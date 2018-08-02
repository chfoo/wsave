package wsave;

class Version {
    // https://code.haxe.org/category/macros/add-git-commit-hash-in-build.html
    public static macro function getGitCommitHash():haxe.macro.Expr.ExprOf<String> {
        #if !display
        var process = new sys.io.Process('git', ['rev-parse', 'HEAD']);
        var commitHash:String;

        if (process.exitCode() != 0) {
            // var message = process.stderr.readAll().toString();
            // var pos = haxe.macro.Context.currentPos();
            // haxe.macro.Context.error("Cannot execute `git rev-parse HEAD`. " + message, pos);
            commitHash = "(none)";
        } else {
            commitHash = process.stdout.readLine();
        }

        return macro $v{commitHash};
        #else
        var commitHash:String = "(none)";
        return macro $v{commitHash};
        #end
    }

    public static macro function getVersion():haxe.macro.Expr.ExprOf<String> {
        #if !display
        var path = haxe.macro.Context.resolvePath("haxelib.json");
        var doc:haxe.DynamicAccess<Any> = haxe.Json.parse(sys.io.File.getContent(path));
        var version:String = doc.get("version");

        return macro $v{version};
        #else
        // `#if display` is used for code completion. In this case returning an
        // empty string is good enough; We don't want to call git on every hint.
        var version:String = "";
        return macro $v{version};
        #end
    }

    public static macro function getBuildDate():haxe.macro.Expr.ExprOf<String> {
        var dateStr = Date.fromTime(Sys.time() * 1000).toString();
        return macro $v{dateStr};
    }
}
