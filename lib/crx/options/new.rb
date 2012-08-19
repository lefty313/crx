module Crx
  module Options

    class New < Default
      attr_accessor :name, :options, :type
      validates :type, presence: true, inclusion: {in: ['popup'], message: "%{value} is wrong type"}

      def initialize(name, options)
        self.name = name
        self.options = options
        self.type = options['type']
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