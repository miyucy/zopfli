#include "ruby.h"
#include "zopfli.h"

#define CSTR2SYM(x)    ID2SYM(rb_intern(x))
#define DEFAULT_FORMAT ZOPFLI_FORMAT_ZLIB

static VALUE rb_mZopfli;

ZopfliFormat
zopfli_deflate_parse_options(ZopfliOptions *options, VALUE opts)
{
    ZopfliFormat format;
    VALUE tmp;

    tmp = rb_hash_aref(opts, CSTR2SYM("format"));
    if (!NIL_P(tmp)) {
        if (tmp == CSTR2SYM("deflate")) {
            format = ZOPFLI_FORMAT_DEFLATE;
        } else if (tmp == CSTR2SYM("gzip")) {
            format = ZOPFLI_FORMAT_GZIP;
        } else if (tmp == CSTR2SYM("zlib")) {
            format = ZOPFLI_FORMAT_ZLIB;
        } else {
            rb_raise(rb_eArgError, "invalid format");
        }
    } else {
        format = DEFAULT_FORMAT;
    }

    tmp = rb_hash_aref(opts, CSTR2SYM("num_iterations"));
    if (!NIL_P(tmp)) {
        options->numiterations = NUM2INT(tmp);
    }

    tmp = rb_hash_aref(opts, CSTR2SYM("block_splitting"));
    if (!NIL_P(tmp)) {
        options->blocksplitting = tmp == Qtrue;
    }

    tmp = rb_hash_aref(opts, CSTR2SYM("block_splitting_last"));
    if (!NIL_P(tmp)) {
        options->blocksplittinglast = tmp == Qtrue;
    }

    tmp = rb_hash_aref(opts, CSTR2SYM("block_splitting_max"));
    if (!NIL_P(tmp)) {
        options->blocksplittingmax = NUM2INT(tmp);
    }

    return format;
}

VALUE
zopfli_deflate(int argc, VALUE *argv, VALUE self)
{
    VALUE   in, out, opts;
    ZopfliOptions options;
    ZopfliFormat   format;
    unsigned char    *tmp = NULL;
    size_t        tmpsize = 0;

    ZopfliInitOptions(&options);

    rb_scan_args(argc, argv, "11", &in, &opts);

    if (!NIL_P(opts)) {
        format = zopfli_deflate_parse_options(&options, opts);
    } else {
        format = DEFAULT_FORMAT;
    }

    StringValue(in);

    ZopfliCompress(&options,
                   format,
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
