require 'delegate'
require 'sprockets'

module Crx
  class SprocketCompiler

    attr_accessor :filter
    attr_reader   :engine

    class Asset < SimpleDelegator
      def save_to(destination)
        filename = destination.join(logical_path)
        filename.dirname.mkpath
        write_to(filename)
      end
    end

    def initialize(engine = nil)
      @engine = engine || Sprockets::Environment.new
      @filter = //
    end

    def append_path(path)
      @engine.append_path path
    end

    def clear_paths
      @engine.clear_paths
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

    def paths
      @engine.each_logical_path(filter)
    end

    def find_asset
      paths.map do |path|
        @engine.find_asset(path)
      end
    end

  end
end