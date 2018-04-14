package wsave.text.codec;

using unifill.Unifill;


class Stream extends List<Int> {
    public static inline var END_OF_STREAM = -1;

    public function prependString(text:String) {
        var codePoints = [];

        for (codePoint in text.uIterator()) {
            codePoints.push(codePoint);
        }

        codePoints.reverse();

        for (codePoint in codePoints) {
            push(codePoint);
        }
    }
}
