 module Crx
  module Options
    class Compile < Default

      attr_reader :destination, :path, :minimize

      validates :destination, presence: true
      validates :minimize, inclusion: {in: [false, true]}

      def initialize(extension_path=nil,options)
        @extension_path = Pathname.new(extension_path || Dir.pwd)
        @path = @extension_path.join('app')
        @destination = options['destination']
        @minimize = options['minimize']
      end

      def target
        @extension_path.join(destination)
      end

      def relative_target
        target.relative_path_from(@extension_path)
      end

    end
  end
end