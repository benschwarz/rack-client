module Rack
  module Client
    class Base
      extend Forwardable

      def_delegator :@app, :call

      def initialize(app, url = nil)
        @app = app
        @base_uri = URI.parse(url) unless url.nil?
      end

      def delete(url, params = {}, headers = {}, body = [])
        call(build_env('DELETE', url, params, headers, body))
      end

      def get(url, params = {}, headers = {}, body = [])
        call(build_env('GET', url, params, headers, body))
      end

      def head(url, params = {}, headers = {}, body = [])
        call(build_env('HEAD', url, params, headers, body))
      end

      def post(url, params = {}, headers = {}, body = [])
        call(build_env('POST', url, params, headers, body))
      end

      def put(url, params = {}, headers = {}, body = [])
        call(build_env('PUT', url, params, headers, body))
      end

      def build_env(request_method, url, params = {}, headers = {}, body = [])
        env = {}
        env.update 'REQUEST_METHOD' => request_method
        env.update 'CONTENT_TYPE'   => 'application/x-www-form-urlencoded'

        uri = @base_uri.nil? ? URI.parse(url) : @base_uri + url
        env.update 'PATH_INFO'   => uri.path
        env.update 'REQUEST_URI' => uri.path
        env.update 'SERVER_NAME' => uri.host
        env.update 'SERVER_PORT' => uri.port

        unless body.nil? || body.empty?
          input = case body
                  when String     then StringIO.new(body)
                  when Array, IO  then body
                  end
          env.update 'rack.input' => input
        end

        env
      end
    end
  end
end