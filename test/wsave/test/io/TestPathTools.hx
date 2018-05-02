package wsave.test.io;

import haxe.io.Path;
import utest.Assert;

using wsave.io.PathTools;


class TestPathTools {
    public function new() {
    }

    public function testContainsPath() {
        Assert.isTrue(new Path("/something/").containsPath(
            new Path("/something/")));

        Assert.isTrue(new Path("/something/").containsPath(
            new Path("/something/index.html")));

        Assert.isTrue(new Path("something/").containsPath(
            new Path("something/index.html")));

        Assert.isFalse(new Path("/something/").containsPath(
            new Path("/other.html")));

        Assert.isFalse(new Path("/something/").containsPath(
            new Path("/other/index.html")));

        Assert.isFalse(new Path("/something/").containsPath(
            new Path("/something")));

        Assert.isFalse(new Path("/something/").containsPath(
            new Path("/somethingelse")));

        Assert.isFalse(new Path("/something/").containsPath(
            new Path("/somethingelse/index.html")));

        Assert.isFalse(new Path("something/").containsPath(
            new Path("somethingelse/index.html")));
    }

    public function testTrimPath() {
        Assert.equals(
            "/world/index.html",
            new Path("/hello/world/index.html")
                .trimPath(new Path("/hello/"))
        );

        Assert.equals(
            "/index.html",
            new Path("/hello/world/index.html")
                .trimPath(new Path("/hello/world/"))
        );

        Assert.equals(
            "index.html",
            new Path("hello/world/index.html")
                .trimPath(new Path("hello/world/"))
        );

        Assert.equals(
            "/hello/world/index.html",
            new Path("/hello/world/index.html")
                .trimPath(new Path("/other/"))
        );

        Assert.equals(
            "hello/world/index.html",
            new Path("hello/world/index.html")
                .trimPath(new Path("other/"))
        );

        Assert.equals(
            "/hello/world/index.html",
            new Path("/hello/world/index.html")
                .trimPath(new Path("/he/"))
        );
    }
}
