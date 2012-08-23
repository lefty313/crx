module Crx
  module Options
    class Compile < Default

      attr_reader :destination, :path, :minimize

      validates :destination, presence: true
      validates :minimize, inclusion: {in: [false, true]}

      def initialize(extension_path=nil,options)
        @path = Pathname.new(extension_path || Dir.pwd)
        @options = options
        @destination = options['destination']
        @minimize = options['minimize']
      end

      def target
        path.join(destination)
      end

    end
  end
end