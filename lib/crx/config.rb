require 'pry'

module Crx
  class Config
    attr_accessor :build_path, :build_format, :compile_path,
    :minimize, :assets_paths, :assets_filters, :merge

    def initialize
      set_defaults
    end

    def set_defaults
      self.build_path   = 'build'
      self.build_format = 'crx'
      self.compile_path = 'build/compile'
      self.minimize     = true
      self.merge        = false
      self.assets_paths = [
        'app/javascripts',
        'app/stylesheets',
        'app/images',
        'app'
      ]
      self.assets_filters = [
        all_files_without_js_css,
        application_js_css
      ]
    end

    private

    def all_files_without_js_css
      Proc.new{ |path| !['.js', '.css'].include?(File.extname(path)) }
    end

    def application_js_css
      /(?:\/|\\|\A)application\.(css|js)$/
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