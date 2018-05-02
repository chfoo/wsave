package wsave.internet.gopher;

import wsave.io.TextStreamIterator;

using StringTools;


class TextFileWriteIterator extends TextStreamIterator {
    override public function next():String {
        if (nextLine.startsWith(".")) {
            nextLine = "." + nextLine;
        }

        return super.next();
    }
}
