package wsave.test.netdata;

import utest.Assert;
import wsave.netdata.NameValueRecord;

using Lambda;


class TestNameValueRecord {
    public function new() {
    }

    public function testConstructor() {
        var record = new NameValueRecord([ "key" => "value" ]);

        Assert.isTrue(record.exists("key"));
    }

    public function testMapMethods() {
        var record = new NameValueRecord();

        Assert.isFalse(record.exists("key-a"));

        record.set("Key-a", "abc");
        record.set("Key-b", "xyz");

        Assert.isTrue(record.exists("key-A"));
        Assert.equals("abc", record.get("key-a"));

        record.remove("key-a");
        Assert.isFalse(record.exists("key-a"));

        Assert.same(["Key-B"], [for (item in record.keys()) item]);
        Assert.same(["xyz"], record.array());
    }

    public function testArrayMethods() {
        var record = new NameValueRecord();

        record.setArray("Key-a", ["abc", "xyz"]);
        record.add("Key-b", "1");
        record.add("Key-b", "2");
        record.add("Key-b", "3");

        Assert.same(["abc", "xyz"], record.getArray("key-a"));
        Assert.same(["1", "2", "3"], record.getArray("key-b"));
    }

    public function testToString() {
        var record = new NameValueRecord();

        record.set("x-key", "123");
        record.add("k", "Hello world!");
        record.add("k", "💾");

        Assert.equals(
            "X-Key: 123\r\n" +
            "K: Hello world!\r\n" +
            "K: 💾\r\n",
            record.toString()
        );
    }

    public function testParse() {
        var record = NameValueRecord.parseString(
            "key-hello: Hello world! 💾\r\n" +
            "key-spacing  :  abc  \r\n" +
            "key-folding: a\r\n" +
            "  b \r\n" +
            "\tc \r\n" +
            "key-repeats: 1\r\n" +
            "key-repeats: 2\r\n" +
            "key-mixed-newlines: test\n" +
            "key-empty-value: \r\n" +
            "key-missing-colon\r\n"
        );

        Assert.equals("Hello world! 💾", record.get("key-hello"));
        Assert.equals("abc", record.get("key-spacing"));
        Assert.equals("a b c", record.get("key-folding"));
        Assert.equals("1", record.get("key-repeats"));
        Assert.same(["1", "2"], record.getArray("key-repeats"));
        Assert.equals("test", record.get("key-mixed-newlines"));
        Assert.equals("", record.get("key-empty-value"));
        Assert.equals("", record.get("key-missing-colon"));
    }

    public function testWithTrailingNewline() {
        var record = NameValueRecord.parseString(
            "something: hello world\r\n"
        );

        Assert.equals(1, record.count());
    }

    public function testWithoutTrailingNewline() {
        var record = NameValueRecord.parseString(
            "something: hello world"
        );

        Assert.equals(1, record.count());
    }
}
