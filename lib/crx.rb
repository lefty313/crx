
require 'core_ext/string'
require 'core_ext/array'
require 'core_ext/thor_actions'

require 'crx/version'
require 'crx/options'
require 'crx/config'
require 'crx/compressors/css'
require 'crx/compressors/js'
require 'crx/options/new'
require 'crx/options/build'
require 'crx/options/compile'
require 'crx/sprocket_compiler'
require 'crx/compiler'
require 'crx/cli'

require 'pry'
module Crx
  Rootpath = Pathname.new(File.expand_path(File.dirname(__FILE__)))

  def self.compiler
    @compiler ||= Crx::Compiler.new(SprocketCompiler.new)
  end

  def self.remove_compiler
    @compiler = nil
  end

  def self.user_dir
    Pathname.new(Dir.pwd)
  end

  private

  def self.try_load_user_config
    config = Pathname.new(Dir.pwd).join("config.rb")
    eval(config.read) if config.exist?
  end
  try_load_user_config
end
