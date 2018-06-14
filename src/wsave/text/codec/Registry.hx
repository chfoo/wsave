package wsave.text.codec;

import wsave.Exception;
import wsave.text.codec.EncodingsLoader;

using StringTools;


class Registry {
    static var labelToNameMap:Map<String,String>;
    static var nameInfoMap:Map<String,EncodingNameInfo>;

    public static function labelToEncodingName(label:String):String {
        initMaps();

        var normalizedLabel = label.trim().toLowerCase();

        if (labelToNameMap.exists(normalizedLabel)) {
            return labelToNameMap.get(normalizedLabel);
        } else {
            throw new ValueException('Encoding for label $label not found.');
        }
    }

    public static function getEncoderHandler(label:String):Handler {
        initMaps();

        var name = labelToEncodingName(label);
        var heading = nameInfoMap.get(name).heading;

        switch (heading) {
            case "The Encoding":
                return new UTF8Encoder();
            case "Legacy single-byte encodings":
                return new SingleByteEncoder(name.toLowerCase());
            case "Legacy multi-byte Chinese (simplified) encodings":
                return new GB18030Encoder(name == "GBK");
            case "Legacy multi-byte Chinese (traditional) encodings":
                throw new NotImplementedException();
            case "Legacy multi-byte Japanese encodings":
                throw new NotImplementedException();
            case "Legacy multi-byte Korean encodings":
                throw new NotImplementedException();
            default:
                switch (name) {
                    case "replacement":
                        throw new ValueException('Cannot use encoding $name.');
                    case "UTF-16BE" | "UTF-16LE":
                        throw new ValueException('No encoder intentionally for encoding $name.');
                    case "x-user-defined":
                        return new XUserDefinedEncoder();
                    default:
                        throw new ValueException('Unsupported encoding $name.');
                }
        }
    }

    public static function getDecoderHandler(label:String):Handler {
        initMaps();

        var name = labelToEncodingName(label);
        var heading = nameInfoMap.get(name).heading;

        switch (heading) {
            case "The Encoding":
                return new UTF8Decoder();
            case "Legacy single-byte encodings":
                return new SingleByteDecoder(name.toLowerCase());
            case "Legacy multi-byte Chinese (simplified) encodings":
                return new GB18030Decoder();
            case "Legacy multi-byte Chinese (traditional) encodings":
                throw new NotImplementedException();
            case "Legacy multi-byte Japanese encodings":
                throw new NotImplementedException();
            case "Legacy multi-byte Korean encodings":
                throw new NotImplementedException();
            default:
                switch (name) {
                    case "replacement":
                        throw new NotImplementedException();
                    case "UTF-16BE" | "UTF-16LE":
                        throw new NotImplementedException();
                    case "x-user-defined":
                        return new XUserDefinedDecoder();
                    default:
                        throw new ValueException('Unsupported encoding $name.');
                }
        }
    }

    static function initMaps() {
        if (labelToNameMap != null) {
            return;
        }

        labelToNameMap = EncodingsLoader.getLabelsToEncodingNameMap();
        nameInfoMap = EncodingsLoader.getEncodingNameInfos();
    }

    public static function getEncoder(encoding:String = "utf-8", ?errorMode:ErrorMode):Encoder {
        var encoderHandler = Registry.getEncoderHandler(encoding);
        var encoder = new Encoder(encoderHandler, errorMode);

        return encoder;
    }

    public static function getDecoder(encoding:String = "utf-8", ?errorMode:ErrorMode):Decoder {
        var decoderHandler = Registry.getDecoderHandler(encoding);
        var decoder = new Decoder(decoderHandler, errorMode);

        return decoder;
    }
}
