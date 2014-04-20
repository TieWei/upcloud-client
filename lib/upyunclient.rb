require "rest-client"
require "digest/md5"
require "base64"
require "time"

require "upyunclient/version"
require "upyunclient/default"
require "upyunclient/configurable"
require "upyunclient/authorization"
require "upyunclient/error"
require "upyunclient/api"


module Upyun
  class Client

    include Upyun::Authorization
    include Upyun::Configurable
    include Upyun::API

    def initialize(options={})
      Upyun::Configurable.keys.each do |key|
        config = options[key] || Upyun::Default.send(key)
        configure(key, config)
      end
      RestClient.log = 'stdout'
      RestClient.add_before_execution_proc do |req, params|
        sign! req
      end
    end

    [:post, :put, :get, :delete, :head].each do |method|
      define_method(method) do |path, opts={}|
        with_upyun do
          url = "http://#{@api_endpoint}/#{path}"
          payload = opts[:payload]
          headers = opts[:headers] || {}
          if [:post, :put].include? method
            return RestClient.send(method, url, payload, headers)
          else
            return RestClient.send(method, url, headers)
          end
        end
      end

    end

    def with_upyun
      begin
        yield
      rescue RestClient::Exception => e
        raise Upyun::Error::RemoteError.from_response(e.response.net_http_res)
      end
    end

  end
end
