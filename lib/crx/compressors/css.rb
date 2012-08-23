module Crx
  module Compressors
    class Css
      def compress(source, options = {})
        require 'yui/compressor'
        engine = YUI::CssCompressor.new(options)
        engine.compress(source)
      end
    end
  end
end