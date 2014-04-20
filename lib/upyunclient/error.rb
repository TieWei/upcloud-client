module Upyun::Error
  class RemoteError < StandardError

    # @param [Hash] response HTTP response
    # @return [Upyun::Error]
    def self.from_response(response)
      status  = response.code.to_i
      msg    = response.msg
      if klass =  case status
                  when 400      then Upyun::Error::BadRequest
                  when 401      then error_for_401(msg)
                  when 403      then error_for_403(msg)
                  when 404      then Upyun::Error::NotFound
                  when 406      then Upyun::Error::NotAcceptable
                  when 400..499 then Upyun::Error::ClientError
                  when 503      then Upyun::Error::SystemError
                  when 500..599 then Upyun::Error::ServerError
                  end
        klass.new(response)
      end
    end

    def initialize(response=nil)
      @response = response
      msg = response.msg + "\n"
      msg << response.body if response.body
      super(msg)
    end

    # Returns most appropriate error for 401 HTTP status code
    # @private
    def self.error_for_401(msg)
      if msg == 'Unauthorized'
        Upyun::Error::Unauthorized
      elsif msg == 'Sign error'
        Upyun::Error::SignError
      elsif msg == 'Need Date Header'
        Upyun::Error::NeedDateHeaderError
      elsif msg == 'Date offset error'
        Upyun::Error::DateOffsetError
      else
        Upyun::Error::UnkonwnUnauthorizedError
      end
    end

    # Returns most appropriate error for 403 HTTP status code
    # @private
    def self.error_for_403(msg)
      if msg == 'Not Access'
        Upyun::Error::NotAccessError
      elsif msg == 'File size too max'
        Upyun::Error::FileTooLargeError
      elsif msg == 'Not a Picture File'
        Upyun::Error::NotPictureFileError
      elsif msg == 'Picture Size too max'
        Upyun::Error::PictureTooLargeError
      elsif msg == 'Bucket full'
        Upyun::Error::BucketFullError
      elsif msg == 'Bucket blocked'
        Upyun::Error::BucketBlockedError
      elsif msg == 'User blocked'
        Upyun::Error::UserBlockedError
      elsif msg == 'Image Rotate Invalid Parameters'
        Upyun::Error::InvalidRotateParameters
      elsif msg == 'Image Crop Invalid Parameters'
        Upyun::Error::InvalidCropParameters
      else
        Upyun::Error::Forbidden
      end
    end

  end

  # Raised on errors in the 400-499 range
  class ClientError < RemoteError; end

  # Raised when Upyun returns a 400 HTTP status code
  class BadRequest < ClientError; end

  # Raised when Upyun returns a 401 HTTP status code
  class Unauthorized < ClientError; end

  # Raised when Upyun returns a 401 HTTP status code
  class SignError < Unauthorized; end

  # Raised when Upyun returns a 401 HTTP status code
  class NeedDateHeaderError < Unauthorized; end

  # Raised when Upyun returns a 401 HTTP status code
  class DateOffsetError < Unauthorized; end

  # Raised when Upyun returns a 401 HTTP status code
  class UnkonwnUnauthorizedError < Unauthorized; end

  # Raised when Upyun returns a 403 HTTP status code
  class Forbidden < ClientError; end

  class NotAccessError < Forbidden; end

  class FileTooLargeError < Forbidden; end

  class NotPictureFileError < Forbidden; end

  class PictureTooLargeError < Forbidden; end

  class BucketFullError < Forbidden; end

  class BucketBlockedError < Forbidden; end

  class UserBlockedError < Forbidden; end

  class InvalidRotateParameters < Forbidden; end

  class InvalidCropParameters < Forbidden; end

  # Raised when Upyun returns a 404 HTTP status code
  class NotFound < ClientError; end

  # Raised when Upyun returns a 406 HTTP status code
  class NotAcceptable < ClientError; end

  # Raised on errors in the 500-599 range
  class ServerError < RemoteError; end

  # Raised when Upyun returns a 503 HTTP status code
  class SystemError < ServerError; end

end