module Crx
  module Compressors
    class Js
      def compress(source, options = {})
        require 'uglifier'
        Uglifier.compile(source, options)
      end
    end
  end
end