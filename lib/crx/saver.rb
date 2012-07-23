require 'json'

module Crx
  module Saver

    attr_accessor :convert_to, :save_path

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def save_object( object, opts)
        define_method(:save) do
          map_opt_to_objects(opts)
          create_dir

          File.open save_path, "w" do |f|
            receiver = instance_variable_get(object)
            f.write receiver.send(convert_to)
          end
          true
        end
      end
    end

    private

    def map_opt_to_objects(opts)
      self.save_path ||= opts[:path]
      self.convert_to ||= opts[:convert] || :to_json
    end

    def dir
      p = Pathname.new save_path
      p.dirname.to_s
    end

    def create_dir
      FileUtils.mkdir_p dir
    end

  end
end