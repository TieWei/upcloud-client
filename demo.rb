lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'upyunclient'

opts = {
	:username => 'username',
	:password => "password",
}

bucket = "bucket"
local_file = "localfile"
filename = "filename"
dir1 = "dir1"
dir2 = "dir1/dir2/dir3"
client = Upyun::Client.new(opts)




client.mkdir(bucket, dir1)
client.mkdir_p(bucket, dir2)

client.rm(dir2)
client.ls dir1
client.info dir1
client.show dir1

client.create(bucket, filename, "#{dir2}/#{local_file}", :mkdir=>true)
client.create(bucket, filename, "#{dir1}/#{local_file}", :mkdir=>true)

client.show "#{dir2}/#{local_file}"
client.show "#{dir1}/#{local_file}"
client.get_file "#{dir2}/#{local_file}"
client.read "#{dir2}/#{local_file}" do |content|
	#do something
end
client.rm "#{dir2}/#{local_file}"
client.rm "#{dir1}/#{local_file}"