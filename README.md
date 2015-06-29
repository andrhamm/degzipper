# Degzipper
Rack middleware to inflate incoming Gzip data from HTTP requests.

[![Build Status](https://travis-ci.org/andrhamm/degzipper.svg)](https://travis-ci.org/andrhamm/degzipper) [![Code Climate](https://codeclimate.com/github/andrhamm/degzipper.png)](https://codeclimate.com/github/andrhamm/degzipper)

## Getting Started
Degzipper is a Rack Middleware. That means that you can use it the same way that you use any other Rack middleware. For example, to use in a Sinatra application I might do this:

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
    
## Try it out

After you install Degzipper to your Rails application, give it a try. Simply gzip a file like so:

	gzip my_file.json

And then send the gzipped file data to your route via a PUT or POST CURL request:

	curl -X PUT --header 'Content-Encoding: gzip' --data-binary @my_file.json.gz http://example.com/myroute
	
Where before you would have been greeted with an ArgumentError like:

	ArgumentError (invalid %-encoding (o?0??+8???ʶd?H?"C??ԥ5<??Y"??H6?????N??߽???Έ???Z?.?????0$ٸߏk0??%4??Vwg*????9?#?7FF?J??D?N

Now your application will recieve the data inflated as if it was never gzipped!


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Credits
Credit to [relistan](https://github.com/relistan) for the [original gist](https://gist.github.com/relistan/2109707)
