package wsave.text;


class StringTextTools {
    public static function splitLines(text:String):Array<String> {
        var pattern = new EReg("\r\n|\r|\n", "g");
        return pattern.split(text);
    }

    public static function toTitleCase(text:String):String {
        var titleCasePattern = new EReg("([^a-z]|^)([a-z])([a-z]*)", "ig");
        return titleCasePattern.map(text, titleCaseCallback);
    }

    static function titleCaseCallback(pattern:EReg):String {
        var nonLetter = pattern.matched(1);
        var firstLetter = pattern.matched(2).toUpperCase();
        var remainingLetters = pattern.matched(3).toLowerCase();
        return '$nonLetter$firstLetter$remainingLetters';
    }
}
