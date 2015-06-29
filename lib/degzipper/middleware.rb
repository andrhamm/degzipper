module Degzipper
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      if method_handled?(env['REQUEST_METHOD']) && encoding_handled?(env['HTTP_CONTENT_ENCODING'])
        extracted = decode(env['rack.input'], env['HTTP_CONTENT_ENCODING'])

        env.delete('HTTP_CONTENT_ENCODING')
        env['CONTENT_LENGTH'] = extracted.bytesize
        env['rack.input'] = StringIO.new(extracted).set_encoding('utf-8')
      end

      @app.call(env)
    end

    private

    def method_handled?(method)
      ['POST', 'PUT', 'PATCH'].include? method
    end

    def encoding_handled?(encoding)
      ['gzip', 'deflate'].include? encoding
    end

    def decode(input, content_encoding)
      case content_encoding
        when 'gzip' then Zlib::GzipReader.new(input).read
        when 'deflate' then Zlib::Inflate.inflate(input.read)
      end
    end
  end
end
