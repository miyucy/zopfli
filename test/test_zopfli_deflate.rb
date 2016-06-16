require "minitest/spec"
require "minitest/autorun"
require "zopfli"
require "stringio"
require "zlib"

describe Zopfli do
  it "works fine" do
    fixture = fixtures("alice29.txt").read

    Zopfli.deflate(fixture).must_equal(Zopfli.deflate(fixture, format: :zlib))
  end

  it "zlib format works" do
    fixture = fixtures("alice29.txt").read

    deflated = Zopfli.deflate fixture, format: :zlib

    uncompressed = Zlib::Inflate.inflate deflated

    uncompressed.must_equal fixture
  end

  it "gzip format works" do
    fixture = fixtures("alice29.txt").read

    deflated = Zopfli.deflate fixture, format: :gzip

    uncompressed = Zlib::GzipReader.wrap(StringIO.new(deflated), &:read)

    uncompressed.must_equal fixture
  end

  it "deflate format works" do
    fixture = fixtures("alice29.txt").read

    Zopfli.deflate fixture, format: :deflate

    skip "How to test"
  end

  def fixtures(name)
    File.open(File.join(File.dirname(__FILE__), "fixtures", name))
  end
end
