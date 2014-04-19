lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'upyunclient'

opts = {
	:username => 'username',
	:password => "password",
}

bucket = "bucket"

client = Upyun::Client.new(opts)
