# Zopfli

see https://github.com/google/zopfli

## Installation

Add this line to your application's Gemfile:

    gem 'zopfli'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install zopfli

## Usage

```ruby
require 'zopfli'

Zopfli.deflate string
# => compressed data

require 'zlib'

compressed_data = Zopfli.deflate string
uncompressed_data = Zlib::Inflate.inflate compressed_data
uncompressed_data == string
# => true
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
