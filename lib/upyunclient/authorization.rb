module Upyun

  module Authorization

    def token(method, uri, content_length=0)

      if @auth == "UpYun"
        signature = md5([method, uri, date, content_length, md5(@password)].join('&'))
        return "#{@auth} #{@username}:#{signature}"
      else
        signature = base64("#{@username}:#{@password}")
        return "#{@auth} #{signature}"
      end

    end

    def sign!(request)
      request['content-length'] ||= 0
      request['date'] = date
      request['host'] = @api_endpoint
      request['authorization'] = token(request.method, request.path, request['content-length'])
    end


    private 

    def md5(data)
      Digest::MD5.hexdigest(data)
    end

    def md5_f(file)
      Digest::MD5.file(file).hexdigest
    end

    def date
      Time.new.httpdate
    end

    def base64(data)
      Base64.encode64(data)
    end

  end
end