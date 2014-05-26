module Upyun

  module Configurable

    attr_reader  :api_endpoint
    attr_reader  :auth
    attr_reader  :username
    attr_reader  :password
 
    class << self

      CONFIG_SCOPE = {
        :api_isp => [:auto, :telecom, :unicom, :mobile],
        :auth => [:basic, :upyun]
      }

      ISP_ENDPOINT = {
        :auto => 'v0.api.upyun.com',
        :telecom => 'v1.api.upyun.com',
        :unicom => 'v2.api.upyun.com',
        :mobile => 'v3.api.upyun.com'
      }

      AUTH_HEAD = {
        :basic => 'Basic',
        :upyun => 'UpYun'
      }

      def keys
        @keys ||= [
          :api_isp,
          :auth,
          :username,
          :password,
          :log
        ]
      end

      def auth_header(auth)
        AUTH_HEAD[auth]
      end
      
      def isp_endpoint(isp)
        ISP_ENDPOINT[isp]
      end

    end

    def configure(key, value)
      if [:username, :password, :log].include? key
        instance_variable_set(:"@#{key}", value)
      elsif key == :auth
        @auth = Upyun::Configurable.auth_header(value)
      else
        @api_endpoint = Upyun::Configurable.isp_endpoint(value)
      end
    end


    
  end
end
