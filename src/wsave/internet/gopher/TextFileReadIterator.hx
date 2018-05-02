package wsave.internet.gopher;

import wsave.io.TextStreamIterator;

using StringTools;


class TextFileReadIterator extends TextStreamIterator {
    override public function hasNext():Bool {
        return super.hasNext() && nextLine.rtrim() != ".";
    }

    override public function next():String {
        var line = super.next();

        if (line.startsWith("..")) {
            line = line.substr(1);
        }

        return line;
    }
}
