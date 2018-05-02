package wsave.test.internet.gopher;

import utest.Assert;
import wsave.Exception;
import wsave.internet.gopher.DirectoryEntity;


class TestDirectoryEntity {
    public function new() {
    }

    public function testParse() {
        var dirEntity = DirectoryEntity.parseString(
            "1Description of file\t/Selector/Name\texample.com\t70\r\n");

        Assert.equals("1", dirEntity.type);
        Assert.equals("Description of file", dirEntity.userName);
        Assert.equals("/Selector/Name", dirEntity.selector);
        Assert.equals("example.com", dirEntity.host);
        Assert.equals(70, dirEntity.port);
    }

    public function testParseExtra() {
        var dirEntity = DirectoryEntity.parseString(
            "1Name\t/Selector\texample.com\t70\tExtra things here\r\n");

        Assert.equals(70, dirEntity.port);
        Assert.equals("Extra things here", dirEntity.extra);
    }

    public function testParseInvalid() {
        Assert.raises(function () {
            DirectoryEntity.parseString(
                "xHello world!\tdummy\tdummy\tdummy\r\n");
        }, ValueException);
    }

    public function testToString() {
        var dirEntity = new DirectoryEntity("h", "Hello world",
            "/Hello world.html", "example.com", 70);

        Assert.equals(
            "hHello world\t/Hello world.html\texample.com\t70\r\n",
            dirEntity.toString()
        );
    }
}
