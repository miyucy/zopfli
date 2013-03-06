#include "ruby.h"
#include "zopfli.h"

static VALUE rb_mZopfli;

VALUE
zopfli_deflate(int argc, VALUE *argv, VALUE self)
{
    VALUE    in, out, opt;
    ZopfliOptions options;
    unsigned char    *tmp = NULL;
    size_t        tmpsize = 0;

    rb_scan_args(argc, argv, "1", &in);

    StringValue(in);

    ZopfliInitOptions(&options);

    ZopfliCompress(&options,
                   ZOPFLI_FORMAT_GZIP,
                   RSTRING_PTR(in), RSTRING_LEN(in),
                   &tmp, &tmpsize);

    out = rb_str_new(tmp, tmpsize);

    free(tmp);

    return out;
}

void
Init_zopfli()
{
    rb_mZopfli = rb_define_module("Zopfli");
    rb_define_singleton_method(rb_mZopfli, "deflate", zopfli_deflate, -1);
    rb_require("zopfli/version");
}
