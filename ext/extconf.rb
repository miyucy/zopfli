# The basic functions to compress data are
# ZopfliDeflate      in deflate.h,
# ZopfliZlibCompress in zlib_container.h
# ZopfliGzipCompress in gzip_container.h.
# Use the ZopfliOptions object to set parameters that affect the speed
# and compression.
# Use the ZopfliInitOptions function to place the default values in
# the ZopfliOptions first.
require "mkmf"

dir_config("zopfli")
if have_header("zopfli/zopfli.h") && have_library("zopfli", "ZopfliCompress", "zopfli/zopfli.h")
  create_makefile "zopfli"
else
  dst = File.dirname File.expand_path __FILE__
  src = File.join dst, "..", "vendor", "zopfli", "src", "zopfli"
  %w[
    blocksplitter.c
    blocksplitter.h
    cache.c
    cache.h
    deflate.c
    deflate.h
    gzip_container.c
    gzip_container.h
    hash.c
    hash.h
    katajainen.c
    katajainen.h
    lz77.c
    lz77.h
    squeeze.c
    squeeze.h
    symbols.h
    tree.c
    tree.h
    util.c
    util.h
    zlib_container.c
    zlib_container.h
    zopfli.h
    zopfli_lib.c
  ].each do |file|
    FileUtils.copy File.join(src, file), File.join(dst, file) if FileTest.exist? File.join(src, file)
  end
  create_makefile "zopfli"
end
