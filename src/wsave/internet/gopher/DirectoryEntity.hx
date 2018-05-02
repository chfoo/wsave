package wsave.internet.gopher;

import wsave.Exception;

using StringTools;


class DirectoryEntity {
    public var type:ItemType;
    public var userName:String;
    public var selector:String;
    public var host:String;
    public var port:Int;
    public var extra:String = "";

    public function new(type:ItemType, userName:String, selector:String, host:String, port:Int) {
        this.type = type;
        this.userName = userName;
        this.selector = selector;
        this.host = host;
        this.port = port;
    }

    public static function parseString(line:String):DirectoryEntity {
        var pattern = new EReg("(.)(.*)\t(.*)\t(.*)\t([0-9]+)\t?(.*)", "");

        if (!pattern.match(line.rtrim())) {
            throw new ValueException("Unknown format.");
        }

        var directoryEntity = new DirectoryEntity(
            pattern.matched(1),
            pattern.matched(2),
            pattern.matched(3),
            pattern.matched(4),
            Std.parseInt(pattern.matched(5))
        );

        directoryEntity.extra = pattern.matched(6);

        return directoryEntity;
    }

    public function toString() {
        return '$type$userName\t$selector\t$host\t$port\r\n';
    }
}
