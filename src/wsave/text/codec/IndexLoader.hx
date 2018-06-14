package wsave.text.codec;

import haxe.Constraints.IMap;
import haxe.Resource;
import haxe.Json;


typedef GB18030Range = {
    pointer:Int,
    codePoint:Int
};


class IndexLoader {
    static function loadJson():Any {
        var text = Resource.getString("encoding/indexes.json");
        var doc = Json.parse(text);
        return doc;
    }

    static function getArray(encoding:String):Array<Any> {
        var doc = loadJson();
        var array:Array<Any> = Reflect.field(doc, encoding);
        return array;
    }

    public static function getPointerToCodePointMap(encoding:String):IMap<Int,Int> {
        var map = new Map<Int,Int>();
        var array = getArray(encoding);

        for (index in 0...array.length) {
            var value = array[index];

            if (value != null) {
                var pointer = index;
                var codePoint = cast(value, Int);
                map.set(pointer, codePoint);
            }
        }

        return map;
    }

    public static function getCodePointToPointerMap(encoding:String):IMap<Int,Int> {
        var map = new Map<Int,Int>();
        var array = getArray(encoding);

        for (index in 0...array.length) {
            var value = array[index];

            if (value != null) {
                var pointer = index;
                var codePoint = cast(value, Int);

                if (!map.exists(codePoint)) {
                    map.set(codePoint, pointer);
                }
            }
        }

        return map;
    }

    public static function getGB18030Ranges():Array<GB18030Range> {
        var array:Array<Array<Int>> = cast getArray("gb18030-ranges");

        var newArray = [];

        for (item in array) {
            newArray.push({
                pointer: item[0],
                codePoint: item[1]
            });
        }

        return newArray;
    }
}
