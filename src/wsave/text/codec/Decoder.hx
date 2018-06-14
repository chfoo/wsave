package wsave.text.codec;

import haxe.io.Bytes;
import unifill.CodePoint;
import wsave.text.TextExceptions;

using commonbox.utils.OptionTools;
using unifill.Unifill;


class Decoder {
    var errorMode:ErrorMode;
    var handler:Handler;
    var input:Stream;
    var output:StringBuf;
    var inputIndex:Int = 0;

    public function new(encoderHandler:Handler, ?errorMode:ErrorMode) {
        this.handler = encoderHandler;
        this.errorMode = errorMode != null ? errorMode : ErrorMode.Replacement;

        input = new Stream();
        output = new StringBuf();
    }

    public function decode(data:Bytes, incremental:Bool = false):String {
        var dataIndex = 0;

        while (true) {
            var byte;

            if (input.length > 0) {
                byte = input.shift().getSome();
            } else if (dataIndex < data.length) {
                byte = data.get(dataIndex);
                dataIndex += 1;
            } else if (!incremental) {
                byte = Stream.END_OF_STREAM;
            } else {
                break;
            }

            var result = process(byte);

            switch (result) {
                case Result.Error(codePoint):
                    throw new EncodingException('Cannot decode byte at position $inputIndex.');
                case Result.Continue:
                    inputIndex += 1;
                default:
                    break;
            }
        }

        var text = output.toString();
        output = new StringBuf();
        return text;
    }

    public function flush():String {
        return decode(Bytes.alloc(0));
    }

    function process(byte:Int):Result {
        var result = handler.process(input, byte);

        switch (result) {
            case Result.Continue | Result.Finished:
                return result;
            case Result.Token(codePoint):
                output.uAddChar(CodePoint.fromInt(codePoint));
            case Result.Tokens(codePoints):
                for (codePoint in codePoints) {
                    output.uAddChar(CodePoint.fromInt(codePoint));
                }
            case Result.Error(codePoint):
                var result = processError(result);
                if (result != null) {
                    return result;
                }
        }

        return Result.Continue;
    }

    function processError(result:Result):Null<Result> {
        switch (errorMode) {
            case ErrorMode.Replacement:
                output.uAddChar(CodePoint.fromInt(0xFFFD));
            case ErrorMode.HTML:
                var codePoint:Int = Type.enumParameters(result)[0];
                input.prependString('&#${Std.string(codePoint)};');
            case ErrorMode.Fatal:
                return result;
        }

        return null;
    }
}
