package wsave.text.codec;

import haxe.io.Bytes;
import unifill.CodePoint;
import wsave.text.TextExceptions;


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

    public function decode(data:Bytes):String {
        var dataIndex = 0;

        while (true) {
            var byte;

            if (input.length > 0) {
                byte = input.pop();
            } else if (dataIndex < data.length) {
                byte = data.get(dataIndex);
                dataIndex += 1;
            } else {
                byte = Stream.END_OF_STREAM;
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

    function process(byte:Int):Result {
        var result = handler.process(input, byte);

        switch (result) {
            case Result.Continue | Result.Finished:
                return result;
            case Result.Token(codePoint):
                output.add(CodePoint.fromInt(codePoint));
            case Result.Tokens(codePoints):
                for (codePoint in codePoints) {
                    output.add(CodePoint.fromInt(codePoint));
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
                output.addChar(0xFFFD);
            case ErrorMode.HTML:
                var codePoint:Int = Type.enumParameters(result)[0];
                input.prependString('&#${Std.string(codePoint)};');
            case ErrorMode.Fatal:
                return result;
        }

        return null;
    }
}
