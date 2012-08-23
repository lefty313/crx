require 'delegate'
require 'sprockets'

module Crx
  class SprocketCompiler

    class Asset < SimpleDelegator
      def save_to(destination)
        filename = destination.join(logical_path)
        FileUtils.mkpath(filename.dirname)
        write_to(filename)
      end
    end

    def initialize(engine = nil)
      @engine = engine || Sprockets::Environment.new
    end

    def append_path(path)
      @engine.append_path path
    end

    def assets
      find_asset.map do |asset|
        Asset.new(asset)
      end
    end

    def js_compressor=(object)
      @engine.js_compressor = object
    end

    def css_compressor=(object)
      @engine.css_compressor = object
    end

    private

    def find_asset
      @engine.each_logical_path.map do |path|
        @engine.find_asset(path)
      end
    end

  end
end