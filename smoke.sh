#!/bin/bash
gem list | grep zopfli && gem uninstall --force zopfli
bundle exec rake clean build
gem install --force --local --no-document "$(ls pkg/zopfli-*.gem)"
cat <<EOF | ruby
require 'zopfli'
require 'zlib'
abort if Zlib::Inflate.inflate(Zopfli.deflate(File.read('smoke.sh'))) != File.read('smoke.sh')
EOF
