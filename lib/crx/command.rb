module Crx

  class Command < ThorCommand

    method_option :mode, aliases: '-m', desc: 'extension ui type', default: 'browser'
    desc "create_folder", "create main extension directory"
    def new(directory)
      empty_directory directory

      inside directory do
        invoke :add, ['manifest']
      end
    end

    desc "add", "add extension files like manifest, content_script"
    def add(name)
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