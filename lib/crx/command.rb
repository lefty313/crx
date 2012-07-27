module Crx

  class Command < ThorCommand

    desc "create_folder", "create main extension directory"
    def create_folder(name)
      empty_directory name
    end

    desc "add", "add extension files like manifest, content_script"
    def add(name)
      @name = name
      template file_type(name)
    end

    private

    def file_type(name)
      raise ArgumentError unless name.respond_to?(:to_s)

      case name.to_s
      when 'manifest' then 'manifest.json'
      else 
        raise ArgumentError, "I don't know how to generete this"
      end

    end

  end
end

