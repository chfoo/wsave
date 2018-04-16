package wsave.text.codec;

import haxe.Resource;
import haxe.Json;


typedef EncodingNameInfo = {
    labels:Array<String>,
    heading:String
};


class EncodingsLoader {
    static function loadJson():Any {
        var text = Resource.getString("encoding/encodings.json");
        var doc = Json.parse(text);
        return doc;
    }

    public static function getEncodingNameInfos():Map<String,EncodingNameInfo> {
        var map = new Map<String,EncodingNameInfo>();
        var doc:Array<Any> = loadJson();

        for (headingDoc in doc) {
            var encodingDocs:Array<Any> = Reflect.field(headingDoc, "encodings");
            var heading:String = Reflect.field(headingDoc, "heading");

            for (encodingDoc in encodingDocs) {
                var name:String = Reflect.field(encodingDoc, "name");
                var labels:Array<String> = Reflect.field(encodingDoc, "labels");

                map.set(name, {
                    labels: labels,
                    heading: heading
                });
            }
        }

        return map;
    }

    public static function getLabelsToEncodingNameMap():Map<String,String> {
        var infoMap = getEncodingNameInfos();
        var map = new Map<String,String>();

        for (name in infoMap.keys()) {
            var info = infoMap.get(name);

            for (label in info.labels) {
                map.set(label, name);
            }
        }

        return map;
    }


}
