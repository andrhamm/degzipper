# Degzipper
Rack middleware to inflate incoming Gzip data from HTTP requests.

## Getting Started
Degzipper is a Rack Middleware. That means that you can use
it the same way that you use any other Rack middleware. For example, to
use in a Sinatra application I might do this:

```ruby
require 'sinatra'
require 'degzipper'

class MyApplication < Sinatra::Base
  use Rack::Session::Cookie
  use Degzipper::Middleware
end
```

For a Rails application this is handled for you automatically, just add the gem to your Gemfile.

## Installation

Add this line to your application's Gemfile:

    gem 'degzipper'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install degzipper

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Credits
Credit to [relistan](https://github.com/relistan) for the [original gist](https://gist.github.com/relistan/2109707)