package wsave.text.codec;

import haxe.io.BytesBuffer;
import haxe.io.Bytes;
import wsave.text.TextExceptions;

using commonbox.utils.OptionTools;
using unifill.Unifill;


class Encoder {
    var errorMode:ErrorMode;
    var handler:Handler;
    var input:Stream;
    var output:BytesBuffer;
    var inputIndex:Int = 0;

    public function new(encoderHandler:Handler, ?errorMode:ErrorMode) {
        this.handler = encoderHandler;
        this.errorMode = errorMode != null ? errorMode : ErrorMode.Fatal;

        input = new Stream();
        output = new BytesBuffer();
    }

    public function encode(text:String):Bytes {
        var codePointIterator = text.uIterator();

        while (true) {
            var codePoint;

            if (input.length > 0) {
                codePoint = input.shift().getSome();
            } else if (codePointIterator.hasNext()) {
                codePoint = codePointIterator.next();
            } else {
                codePoint = Stream.END_OF_STREAM;
            }

            var result = process(codePoint);

            switch (result) {
                case Result.Error(codePoint):
                    throw new EncodingException('Cannot encode $codePoint at position $inputIndex.');
                case Result.Continue:
                    inputIndex += 1;
                default:
                    break;
            }
        }

        var data = output.getBytes();
        output = new BytesBuffer();
        return data;
    }

    function process(codePoint:Int):Result {
        var result = handler.process(input, codePoint);

        switch (result) {
            case Result.Continue | Result.Finished:
                return result;
            case Result.Token(byte):
                output.addByte(byte);
            case Result.Tokens(bytes):
                for (byte in bytes) {
                    output.addByte(byte);
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
                output.addByte("?".code);
            case ErrorMode.HTML:
                var codePoint:Int = Type.enumParameters(result)[0];
                input.prependString('&#${Std.string(codePoint)};');
            case ErrorMode.Fatal:
                return result;
        }

        return null;
    }
}
