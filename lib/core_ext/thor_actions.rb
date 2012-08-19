require 'thor'

module Thor::Actions
	def copy_files(files)
		files.each do |file|
			copy_file file.from, file.to
		end
	end

	def apply_templates(files)
		files.each do |file|
			template file.from, file.to
		end
	end
end