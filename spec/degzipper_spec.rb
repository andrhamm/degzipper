require 'degzipper'
require 'json'
require 'rack'
require 'zlib'

RSpec.describe Degzipper::Middleware do
  def make_request(input, encoding)
    body = middleware.call(Rack::MockRequest.env_for(
      '/',
      method: 'POST',
      input: input,
      'HTTP_CONTENT_ENCODING' => encoding
    ))[2]

    JSON.parse(body)
  end

  let(:middleware) do
    Degzipper::Middleware.new(-> (env) do
      req = Rack::Request.new(env)

      body = JSON.dump(
        body: req.body.read,
        content_encoding: env['HTTP_CONTENT_ENCODING'],
        length: req.content_length.to_i
      )

      [200, {}, body]
    end)
  end

  it 'passes through a non-gzipped request body' do
    resp = make_request('hello', nil)

    expect(resp).to eq(
      'body' => 'hello',
      'content_encoding' => nil,
      'length' => 5
    )
  end

  shared_examples_for 'a compression' do |type|
    it 'extracts a compressed request body' do
      resp = make_request(compress('hello'), type)

      expect(resp).to eq(
        'body' => 'hello',
        'content_encoding' => nil,
        'length' => 5
      )
    end

    it 'sets the correct content length for UTF-8 content' do
      resp = make_request(compress('你好'), type)

      expect(resp).to eq(
        'body' => '你好',
        'content_encoding' => nil,
        'length' => 6
      )
    end

    it 'handles a tmp files as well' do
      Tempfile.open('degzipper') do |stream|
        stream << compress('hello')
        stream.rewind
        resp = make_request(stream, type)

        expect(resp).to eq(
          'body' => 'hello',
          'content_encoding' => nil,
          'length' => 5
        )
      end
    end
  end

  context 'gzip' do
    it_behaves_like 'a compression', 'gzip'

    def compress(content)
      string_io = StringIO.new

      gz = Zlib::GzipWriter.new(string_io)
      gz.write content
      gz.close

      string_io.string
    end
  end


  context 'zlib' do
    it_behaves_like 'a compression', 'zlib'

    def compress(content)
      Zlib::Deflate.deflate(content)
    end
  end

  context 'deflate' do
    it_behaves_like 'a compression', 'deflate'

    def compress(content)
      stream = Zlib::Deflate.new(Zlib::DEFAULT_COMPRESSION, -Zlib::MAX_WBITS)
      result = stream.deflate(content, Zlib::FINISH)
      stream.close
      result
    end
  end
end
