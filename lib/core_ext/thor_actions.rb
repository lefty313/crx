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

  def say_relative_path(status, message, log_status = true)
    message = relative_to_original_destination_root(message.to_s)
    say_status(status, message, log_status) 
  end

  def clean_or_create_directory(path)
    path = Pathname.new(path)
    remove_dir(path, verbose: false) if path.exist?
    empty_directory(path, verbose: false)
    say_relative_path('clean', path)
  end
end