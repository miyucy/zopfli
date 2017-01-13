require 'spec_helper'
require 'zlib'
require 'stringio'
require 'benchmark'
require 'thread'

RSpec.describe Zopfli do
  let(:fixture) { File.read(File.expand_path('fixtures/alice29.txt', File.dirname(__FILE__))) }

  it 'works' do
    expect(Zopfli.deflate(fixture)).to eq Zopfli.deflate(fixture, format: :zlib)
  end

  it 'works (zlib format)' do
    deflated = Zopfli.deflate fixture, format: :zlib

    uncompressed = Zlib::Inflate.inflate deflated

    expect(uncompressed).to eq fixture
  end

  it 'works (gzip format)' do
    deflated = Zopfli.deflate fixture, format: :gzip

    uncompressed = Zlib::GzipReader.wrap(StringIO.new(deflated), &:read)

    expect(uncompressed).to eq fixture
  end

  it 'works (deflate format)' do
    deflated = Zopfli.deflate fixture, format: :deflate
    p fixture.bytesize, deflated.bytesize
  end
end
