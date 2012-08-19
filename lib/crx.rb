require 'core_ext/string'
require 'core_ext/array'
require 'core_ext/thor_actions'

require 'crx/version'
require 'crx/options'
require 'crx/options/new'
require 'crx/options/build'
require 'crx/cli'

module Crx
  Rootpath = File.expand_path(File.dirname(__FILE__))
end
