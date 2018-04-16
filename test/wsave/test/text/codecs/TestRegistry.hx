package wsave.test.text.codecs;

import utest.Assert;
import wsave.Exception;
import wsave.text.codec.Registry;
import wsave.text.codec.SingleByteDecoder;
import wsave.text.codec.SingleByteEncoder;
import wsave.text.codec.UTF8Decoder;
import wsave.text.codec.UTF8Encoder;
import wsave.text.codec.XUserDefinedDecoder;
import wsave.text.codec.XUserDefinedEncoder;


class TestRegistry {
    public function new() {
    }

    public function testLabelToEncodingName() {
        Assert.equals("UTF-8", Registry.labelToEncodingName("Utf8"));
        Assert.equals("windows-1252", Registry.labelToEncodingName("latin1"));
    }

    public function testLabelToEncodingNameNotFound() {
        Assert.raises(function () {
            Registry.labelToEncodingName("invalid");
        }, ValueException);
    }

    public function testGetEncoderHandler() {
        Assert.is(Registry.getEncoderHandler("utf8"), UTF8Encoder);
        Assert.is(Registry.getEncoderHandler("latin2"), SingleByteEncoder);
        // Assert.is(Registry.getEncoderHandler("gbk"), Todo);
        // Assert.is(Registry.getEncoderHandler("big5"), Todo);
        // Assert.is(Registry.getEncoderHandler("shift_jis"), Todo);
        // Assert.is(Registry.getEncoderHandler("euc-kr"), Todo);
        Assert.is(Registry.getEncoderHandler("x-user-defined"), XUserDefinedEncoder);
    }

    public function testGetEncoderHandlerError() {
        Assert.raises(function () {
            Registry.getEncoderHandler("replacement");
        }, ValueException);
        Assert.raises(function () {
            Registry.getEncoderHandler("utf-16be");
        }, ValueException);
        Assert.raises(function () {
            Registry.getEncoderHandler("invalid");
        }, ValueException);
    }

    public function testGetDecoderHandler() {
        Assert.is(Registry.getDecoderHandler("utf8"), UTF8Decoder);
        Assert.is(Registry.getDecoderHandler("latin2"), SingleByteDecoder);
        // Assert.is(Registry.getDecoderHandler("gbk"), Todo);
        // Assert.is(Registry.getDecoderHandler("big5"), Todo);
        // Assert.is(Registry.getDecoderHandler("shift_jis"), Todo);
        // Assert.is(Registry.getDecoderHandler("euc-kr"), Todo);
        Assert.is(Registry.getDecoderHandler("x-user-defined"), XUserDefinedDecoder);
    }
}
