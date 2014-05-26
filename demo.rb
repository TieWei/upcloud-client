lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'upyunclient'
require 'logger'

opts = {
	:username => 'username',
	:password => "password",
	:logger => Logger.new(STDOUT)
}

bucket = "bucket"
local_file = "a local file to upload"
filename = "filename"
dir1 = "dir1"
dir2 = "dir1/dir2/dir3"
client = Upyun::Client.new(opts)

client.mkdir(bucket, dir1)
client.mkdir_p(bucket, dir2)

client.rm(bucket, dir2)
client.ls(bucket, dir1)
client.info(bucket, dir1)
client.show(bucket, dir1)

client.create(bucket, "#{dir2}/#{filename}", local_file, :mkdir=>true)
client.create(bucket, "#{dir1}/#{filename}", local_file, :mkdir=>true)

client.show bucket, "#{dir2}/#{filename}"
client.show bucket, "#{dir1}/#{filename}"
client.get_file bucket, "#{dir2}/#{filename}"
client.read bucket, "#{dir2}/#{filename}" do |content|
	#do something
	puts content
end
client.rm bucket, "#{dir2}/#{filename}"
client.rm bucket, "#{dir1}/#{filename}"