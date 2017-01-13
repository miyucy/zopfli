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

  context 'benchmark' do
    it 'seq' do
      data = 10.times.map { fixture.dup }
      deflates = nil
      t = Benchmark.realtime { deflates = data.map { |datum| Zopfli.deflate datum } }
      deflates.each { |deflate| expect(Zlib::Inflate.inflate(deflate)).to eq fixture }
      puts t
      # => 4.483513999963179
    end

    it 'thread' do
      q = Queue.new
      10.times { q.push fixture.dup }
      10.times { q.push nil }
      w = 10.times.map do
        Thread.new do
          deflates = []
          loop do
            datum = q.pop
            break if datum.nil?
            deflates << Zopfli.deflate(datum)
          end
          deflates
        end
      end
      deflates = nil
      t = Benchmark.realtime { deflates = w.map(&:value) }
      deflates.flatten.each { |deflate| expect(Zlib::Inflate.inflate(deflate)).to eq fixture }
      puts t
      # => 2.6099140000296757
      # => 0.9405940000433475 (w/o gvl)
    end
  end
end
