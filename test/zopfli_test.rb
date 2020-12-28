# frozen_string_literal: true

require "test_helper"
require "zlib"
require "stringio"

class ZopfliTest < Test::Unit::TestCase
  T = [*"a".."z", *"A".."Z", *"0".."9"].freeze

  def random_data(length = 1024)
    Array.new(length) { T.sample }.join
  end

  test "VERSION" do
    assert do
      ::Zopfli.const_defined?(:VERSION)
    end
  end

  test "well done" do
    s = random_data
    assert_equal s, Zlib::Inflate.inflate(Zopfli.deflate(s, format: :zlib))
  end

  test "well done(default format is zlib)" do
    s = random_data
    assert_equal Zopfli.deflate(s, format: :zlib), Zopfli.deflate(s)
  end

  test "well done(gzip format)" do
    s = random_data
    assert_equal s, Zlib::GzipReader.wrap(StringIO.new(Zopfli.deflate(s, format: :gzip)), &:read)
  end

  test "well done(deflate)" do
    s = random_data
    assert_nothing_raised do
      Zopfli.deflate(s, format: :deflate)
    end
  end

  test "raise error when pass invalid format" do
    s = random_data
    assert_raise ArgumentError do
      Zopfli.deflate(s, format: :lzma)
    end
  end

  sub_test_case "Ractor safe" do
    test "able to invoke non-main ractor" do
      unless defined? ::Ractor
        notify "Ractor not defined"
        omit
      end
      a = Array.new(2) do
        Ractor.new(random_data) do |s|
          Zlib::Inflate.inflate(Zopfli.deflate(s)) == s
        end
      end
      assert_equal [true, true], a.map(&:take)
    end
  end
end
