require 'delegate'

module Crx

  # compiler should respond_to :append_path, :assets, :js_compressor, :css_compressor, :filter, :clear_paths
  class Compiler < SimpleDelegator

    def add_path(path)
      append_path(path)
    end

    def compile_to(path, opt={})
      remove_compressors

      if opt[:minimize]
        self.js_compressor  = Compressors::Js.new
        self.css_compressor = Compressors::Css.new
      end

      if opt[:merge]
        self.filter = Crx.config.assets_filters
      end

      assets.each {|asset| asset.save_to(path) }
    end
    
    private

    def remove_compressors
      self.js_compressor  = nil
      self.css_compressor = nil
    end
  end


end