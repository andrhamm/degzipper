require 'degzipper'
require 'json'
require 'rack'
require 'zlib'

RSpec.describe Degzipper::Middleware do
  def gzip(content)
    string_io = StringIO.new

    gz = Zlib::GzipWriter.new(string_io)
    gz.write content
    gz.close

    string_io.string
  end

  let(:middleware) do
    Degzipper::Middleware.new(-> (env) do
      req = Rack::Request.new(env)

      body = JSON.dump(
        body: req.body.read,
        content_encoding: env['HTTP_CONTENT_ENCODING'],
        length: req.content_length.to_i
      )

      [200, {}, [body]]
    end)
  end

  it 'passes through a non-gzipped request body' do
    _, _, body = middleware.call(Rack::MockRequest.env_for(
      '/',
      method: 'POST',
      input: 'hello'
    ))

    parsed_body = JSON.parse(body.first)

    expect(parsed_body).to eq(
      'body' => 'hello',
      'content_encoding' => nil,
      'length' => 5
    )
  end

  it 'extracts a gzipped request body' do
    _, _, body = middleware.call(Rack::MockRequest.env_for(
      '/',
      method: 'POST',
      input: gzip('hello'),
      'HTTP_CONTENT_ENCODING' => 'gzip'
    ))

    parsed_body = JSON.parse(body.first)

    expect(parsed_body).to eq(
      'body' => 'hello',
      'content_encoding' => nil,
      'length' => 5
    )
  end
end
