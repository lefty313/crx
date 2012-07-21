require 'forwardable'
require 'yaml'

module Crx
  class Manifest < Struct.new(:opt)
    extend Forwardable 
    include Crx::Saver

    def_delegator :opt, :to_yaml

    def path
      "manifest.yml"
    end

    def file
      opt
    end

  end
end