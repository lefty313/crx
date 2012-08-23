require 'delegate'

module Crx

  # compiler should respond_to :append_path, :assets, :js_compressor, :css_compressor
  class Compiler < SimpleDelegator

    def add_path(path)
      append_path(path)
    end

    def compile_to(path, opt={})
      if opt[:minimize]
        __getobj__.js_compressor  = Compressors::Js.new
        __getobj__.css_compressor = Compressors::Css.new
      end

      assets.each {|asset| asset.save_to(path) }
    end
  end
end