#include "ruby.h"
#include "ruby/thread.h"
#include "zopfli.h"

#define CSTR2SYM(x)    ID2SYM(rb_intern(x))
#define DEFAULT_FORMAT ZOPFLI_FORMAT_ZLIB

static VALUE rb_mZopfli;

static ZopfliFormat
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

typedef struct {
    ZopfliOptions options;
    ZopfliFormat   format;
    unsigned char     *in;
    size_t         insize;
    unsigned char    *out;
    size_t        outsize;
} zopfli_deflate_args_t;

static void*
zopfli_deflate_no_gvl(void* arg)
{
    zopfli_deflate_args_t *args = (zopfli_deflate_args_t*)arg;

    ZopfliCompress(&args->options, args->format,
                   args->in, args->insize,
                   &args->out, &args->outsize);

    return arg;
}

static VALUE
zopfli_deflate(int argc, VALUE *argv, VALUE self)
{
    zopfli_deflate_args_t args;
    VALUE in, out, opts;

    ZopfliInitOptions(&args.options);

    rb_scan_args(argc, argv, "11", &in, &opts);

    if (!NIL_P(opts)) {
        args.format = zopfli_deflate_parse_options(&args.options, opts);
    } else {
        args.format = DEFAULT_FORMAT;
    }

    StringValue(in);

    args.in = (unsigned char*)RSTRING_PTR(in);
    args.insize = RSTRING_LEN(in);

    args.out = NULL;
    args.outsize = 0;

    rb_thread_call_without_gvl(zopfli_deflate_no_gvl, (void *)&args, NULL, NULL);

    out = rb_str_new((const char*)args.out, args.outsize);

    free(args.out);

    return out;
}

void
Init_zopfli()
{
    rb_mZopfli = rb_define_module("Zopfli");
    rb_define_singleton_method(rb_mZopfli, "deflate", zopfli_deflate, -1);
}
