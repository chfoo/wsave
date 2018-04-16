package wsave.text.codec;


class ReplacementDecoder implements Handler {
    var errorReturned = false;

    public function process(stream:Stream, byte:Int):Result {
        if (byte == Stream.END_OF_STREAM) {
            return Result.Finished;
        } else if (!errorReturned) {
            errorReturned = true;
            return Result.Error(CodecTools.INT_NULL);
        } else {
            return Result.Finished;
        }
    }
}
