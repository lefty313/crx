require 'forwardable'
require 'yaml'

module Crx
  class Manifest < Struct.new(:opt)
    extend Forwardable 

    def_delegator :opt, :to_yaml

  end
end