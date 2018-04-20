package wsave.io;

import wsave.io.IOExceptions;
import wsave.text.codec.Decoder;
import wsave.text.codec.ErrorMode;
import wsave.text.codec.Registry;


class TextReader {
    var inputStream:IInputStream;
    var decoder:Decoder;
    var scanner:TextScanner;
    var chunkSize = 8192;

    public function new(inputStream:IInputStream, encoding:String = "utf-8", ?errorMode:ErrorMode) {
        this.inputStream = inputStream;
        decoder = Registry.getDecoder(encoding, errorMode);
        scanner = new TextScanner();
    }

    public function read(amount:Int = -1):String {
        if (amount < 0) {
            var data = inputStream.read(-1);
            scanner.pushString(decoder.decode(data));

            return scanner.shiftString();
        }

        fillBuffer(amount);

        return scanner.shiftString(amount);
    }

    public function readLine(keepEnd:Bool = false):String {
        while (!(scanner.hasNewline() && !scanner.isNewlineAmbiguous())) {
            readIntoBuffer(chunkSize, true);
        }

        return scanner.shiftLine(keepEnd);
    }

    public function readUntil(separator:Int = "\n".code, keepEnd:Bool = false):String {
        var separatorIndex = scanner.indexOf(separator);

        while (separatorIndex < 0) {
            readIntoBuffer(chunkSize, true);
            separatorIndex = scanner.indexOf(separator);
        }

        if (keepEnd) {
            return scanner.shiftString(separatorIndex + 1);
        } else {
            var output = scanner.shiftString(separatorIndex);
            scanner.shiftString(1);
            return output;
        }
    }

    function fillBuffer(minimum:Int) {
        while (true) {
            var codePointsNeeded = minimum - scanner.length;

            if (codePointsNeeded <= 0) {
                break;
            }

            readIntoBuffer(codePointsNeeded + 4);
        }
    }

    function readIntoBuffer(amount:Int, throwIncomplete:Bool = false) {
        var data;
        try {
            data = inputStream.read(amount);
        } catch (exception:EndOfFile) {
            if (scanner.length == 0) {
                throw exception;
            } else if (throwIncomplete) {
                throw new IncompleteTextRead('', scanner.shiftString());
            } else {
                return;
            }
        }

        scanner.pushString(decoder.decode(data));
    }
}
