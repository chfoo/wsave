package wsave.internet.gopher;

@:enum
abstract ItemType(String) to String from String {
    static inline var FILE_TYPES = "04569gIhs";
    static inline var SERVER_TYPES = "1278+T";
    static inline var DUMMY_TYPES = "3i";

    var TextFile = "0";
    var Menu = "1";
    var CSOServer = "2";
    var Error = "3";
    var BinHexFile = "4";
    var DOSFile = "5";
    var UuencodeFile = "6";
    var FullTextSearchServer = "7";
    var TelnetServer = "8";
    var BinaryFile = "9";
    var DuplicateServer = "+";
    var GIFFile = "g";
    var ImageFile = "I";
    var Telnet3270Server = "T";
    var HTMLFIle = "h";
    var Informational = "i";
    var SoundFile = "s";

    public function isFile():Bool {
        return FILE_TYPES.indexOf(this) >= 0;
    }

    public function isMenu():Bool {
        return this == Menu;
    }

    public function isServer():Bool {
        return SERVER_TYPES.indexOf(this) >= 0;
    }

    public function isDummy():Bool {
        return DUMMY_TYPES.indexOf(this) >= 0;
    }
}
