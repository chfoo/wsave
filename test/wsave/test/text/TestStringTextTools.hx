package wsave.test.text;

import utest.Assert;

using wsave.text.StringTextTools;


class TestStringTextTools {
    public function new() {
    }

    public function testSplitLinesN() {
        Assert.same(["a", "b", "c"], "a\nb\nc".splitLines());
        Assert.same(["", "a", "", "b", ""], "\na\n\nb\n".splitLines());
    }

    public function testSplitLinesR() {
        Assert.same(["a", "b", "c"], "a\rb\rc".splitLines());
        Assert.same(["", "a", "", "b", ""], "\ra\r\rb\r".splitLines());
    }

    public function testSplitLinesRN() {
        Assert.same(["a", "b", "c"], "a\r\nb\r\nc".splitLines());
        Assert.same(["", "a", "", "b", ""], "\r\na\r\n\r\nb\r\n".splitLines());
    }

    public function testSplitLinesMixed() {
        Assert.same(["a", "", "b"], "a\n\rb".splitLines());
        Assert.same(["a", "b", "c", "d"], "a\rb\nc\r\nd".splitLines());
    }

    public function testToTitleCase() {
        Assert.equals("Hello-World", "hello-world".toTitleCase());
        Assert.equals(" Hello World!", " hello world!".toTitleCase());
        Assert.equals("Hello-World", "HELLO-WORLD".toTitleCase());
        Assert.equals("Hello_World", "hello_world".toTitleCase());
        Assert.equals("Hello123World", "hello123world".toTitleCase());
    }
}
