require 'pry'

module Crx
  class Config
    attr_accessor :build_path, :build_format, :compile_path, :minimize, :assets_paths

    def initialize
      self.build_path   = 'build'
      self.build_format = 'crx'
      self.compile_path = 'build/compile'
      self.minimize     = true
      self.assets_paths = [
        'app',
        'app/javascripts',
        'app/stylesheets',
        'app/images'
      ]
    end
  end

  class << self
    attr_accessor :config
    Crx.config ||= Config.new
  end

  def self.configure
    yield config
  end
end