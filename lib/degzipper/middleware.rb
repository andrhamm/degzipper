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
      ['gzip', 'zlib', 'deflate'].include? encoding
    end

    def decode(input, content_encoding)
      # type of input depends on CONTENT_LENGTH
      # if CONTENT_LENGTH < 20k it's StringIO; if more it's Tempfile
      # that's why use only common methods of these types
      case content_encoding
        when 'gzip' then Zlib::GzipReader.new(input).read
        when 'zlib' then Zlib::Inflate.inflate(input.read)
        when 'deflate'
          stream = Zlib::Inflate.new(-Zlib::MAX_WBITS)
          content = stream.inflate(input.read)
          stream.finish
          stream.close
          content
      end
    end
  end
end
