module Upyun
	module API

		def bucket_usage(bucket)
			get("#{bucket}/?usage")
		end

		def mkdir(bucket, dir, mkpath=false)
			headers = {'folder' => true, 'mkdir' => mkpath}
			path = build_path(bucket, dir)
			post(path, :headers=>headers)
		end

		alias create_dir mkdir

		def mkdir_p(bucket, dir)
			mkdir(bucket, dir, mkpath=true)
		end

		alias create_dir_p mkdir_p

		def rm(bucket, path)
			delete(build_path(bucket, path))
		end

		alias delete_dir rm
		alias delete_file rm
		alias delete rm
		alias remove_dir rm
		alias remove_file rm
		alias remove rm

		def ls(bucket, path)
			raw = get("#{build_path(bucket, path)}/")
			info = []
			raw.split("\n").each do |raw_detail|
				file = {}
				detail = raw_detail.split("\t")
				file[:name] = detail[0]
				file[:type] = :file if detail[1] == 'N'
				file[:type] = :folder if detail[1] == 'F'
				file[:size] = detail[2].to_i
				file[:update_at] = detail[3].to_i
				info << file
			end
			info
		end

		alias ls_dir ls

		def info(bucket, path)
			raw = head(build_path(bucket, path)).raw_headers
			info = {}
			info[:path] = path
			info[:bucket] = bucket
			info[:type] = raw['x-upyun-file-type']
			info[:size] = raw['x-upyun-file-size']
			info[:create_at] = raw['x-upyun-file-date']
			info
		end

		alias show info

		def get_file(bucket, path)
			raw = get(build_path(bucket,path))
			if block_given?
				yield raw
			else
				return raw
			end
		end

		alias download get_file
		alias get_f get_file

		def create(bucket, upload_path, local_file, opts={})
			headers = {}

			headers['mkdir'] = true if true == opts[:mkdir]

			headers['Content-MD5'] = md5_f(local_file) if true == opts[:md5]

			headers['Content-Secret'] = opts[:secret] if opts[:secret]

			headers['Content-Type'] = opts[:content] if opts[:content]

			if opts[:quality] && opts[:quality] >= 1 && opts[:quality] <= 100
				headers['x-gmkerl-quality'] = opts[:quality]
			end

			headers['x-gmkerl-unsharp'] = true	if true == opts[:unsharp]

			headers['x-gmkerl-thumbnail'] = opts[:thumbnail] if opts[:thumbnail]

			headers['x-gmkerl-exif-switch'] = true if true == opts[:keep_exif]

			if opts[:crop_type] && opts[:crop_value] && _CROP_TYPES.include?(opts[:crop_type])
				set = false
				value = opts[:crop_value]
				if [:fix_width_or_height, :fix_both].include?(opts[:crop_type]) && value =~ /^\d+x\d+$/i
						set = true
				elsif :fix_scale == opts[:crop_type]
					set = true  if value.is_a?(Integer) && value >= 1 && value <=99
				else
					set = true  if value.is_a?(Integer)
				end

				if set
					headers['x-gmkerl-type'] = opts[:crop_type].to_s
					headers['x-gmkerl-value'] = value
				end

			end
			path = build_path(bucket, upload_path)
			put(path, :payload => File.read(local_file), :headers => headers)
		end

		alias upload create

		private

		def build_path(bucket, path)
			"#{bucket}#{format(path)}"
		end

		def format(path)
			if path.start_with? "/"
				return path
			else
			 	return "/#{path}"
			end
		end

		_CROP_TYPES=[:fix_width, :fix_height, :fix_width_or_height,
								 :fix_both, :fix_max, :fix_min, :fix_scale]

	end
end