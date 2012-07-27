require 'thor'

# https://github.com/wycats/thor/blob/master/spec/actions/file_manipulation_spec.rb
# http://rdoc.info/github/wycats/thor/master/Thor/Actions#template-instance_method

module Crx

  class Command < Thor
    include Thor::Actions

    def self.source_root
      File.join(Crx::Rootpath, 'crx/templates')
    end

    desc "create_folder", "create main extension directory"
    def create_folder(name)
      empty_directory name
    end

    desc "add", "add extension files like manifest, content_script"
    def add(name)
      template file_type(name)
    end

    private

    def destination_path(name)

    end

    def file_type(name)
      raise ArgumentError unless name.respond_to?(:to_s)

      case name.to_s
      when 'manifest' then 'manifest.rb'
      else 
        raise ArgumentError, "I don't know how to generete this"
      end

    end

  end
end

