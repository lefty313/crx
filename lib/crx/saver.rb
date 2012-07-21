require 'json'

module Crx
  module Saver

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def save_object( object, opts)
        define_method(:save) do
          File.open(opts[:path],"w") do |f|
            receiver = instance_variable_get(object)
            f.write(receiver.send(opts[:convert] || :to_json))
          end
        end
      end
    end

  end
end