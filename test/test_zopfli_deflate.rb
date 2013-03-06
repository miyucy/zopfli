require "minitest/spec"
require "minitest/autorun"
require "zopfli"
require "stringio"
require "zlib"

describe Zopfli do
  it "should compatible to gzip" do
    fixture = fixtures("alice29.txt").read

    sio = StringIO.new(Zopfli.deflate fixture)

    uncompressed = nil
    Zlib::GzipReader.wrap(sio) do |gz|
      uncompressed = gz.read
    end

    fixture.must_equal uncompressed
  end

  def fixtures(name)
    File.open(File.join File.dirname(__FILE__), "fixtures", name)
  end
end
