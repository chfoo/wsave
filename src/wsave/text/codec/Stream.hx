package wsave.text.codec;

import commonbox.ds.Deque;

using unifill.Unifill;


class Stream extends Deque<Int> {
    public static inline var END_OF_STREAM = -1;

    public function prependString(text:String) {
        var codePoints = [];

        for (codePoint in text.uIterator()) {
            codePoints.push(codePoint);
        }

        codePoints.reverse();

        for (codePoint in codePoints) {
            unshift(codePoint);
        }
    }
}
