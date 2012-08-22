require 'core_ext/string'
require 'core_ext/array'
require 'core_ext/thor_actions'

require 'crx/version'
require 'crx/options'
require 'crx/options/new'
require 'crx/options/build'
require 'crx/root'
require 'crx/cli'

require 'pry'
module Crx
  Rootpath = Pathname.new(File.expand_path(File.dirname(__FILE__)))
end
