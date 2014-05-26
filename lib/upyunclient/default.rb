module Upyun

  module Default

    # Default API ISP
    API_ISP = :auto

    # Default Authorization
    AUTHORIZATION = :upyun

    class << self

      def api_isp
        if ENV['UPYUN_API_ISP']
          return ENV['UPYUN_API_ISP'].downcase.to_sym
        else
          return API_ISP
        end
      end

      def auth
        if ENV['UPYUN_AUTHORIZATION']
          return ENV['UPYUN_AUTHORIZATION'].downcase.to_sym
        else
          return AUTHORIZATION
        end
      end

      def username
        ENV['UPYUN_USERNAME']
      end

      def password
        ENV['UPYUN_PASSWORD']
      end

      def log
        if ENV['UPYUN_LOG']
          ENV['RESTCLIENT_LOG'] = ENV['UPYUN_LOG']
          return ENV['UPYUN_LOG']
        else
          return "stdout"
        end
      end

    end

  end

end