require 'active_model'
require 'active_model/validations'

module Crx
  module Options
    class FileContainer < Struct.new(:from,:to)
    end

    class New
      include ActiveModel::Validations

      attr_accessor :name, :options, :type
      validates :type, presence: true, inclusion: {in: ['popup'], message: "%{value} is wrong type"}

      def initialize(name, options, force_validate=false)
        self.name = name
        self.options = options
        self.type = options['type']

        if force_validate
          raise errors.full_messages.join(', ') unless valid?
        end
      end

      def target
        File.join(Dir.pwd,name)
      end

      def templates
        files = ['manifest.json','index.html','index.js']
        files = files.map do |file|
          FileContainer.new(File.join(type,file),File.join(target,file))
        end
      end

      def files
        files = ['icon.png']
        files = files.map do |file|
          FileContainer.new(File.join(type,file),File.join(target,file))
        end
      end
    end
  end
end