require 'forwardable'

module Crx
  class Plugin < Struct.new(:opts)
    extend Forwardable

    def_delegator :@manifest, :save, :save_manifest

    attr_accessor :name, :description, :version

    def initialize(opts)
      self.name = opts[:name]
      self.description = opts[:description]
      self.version = opts[:version] || "0.0.1"
      @manifest = Manifest.new(opts)
    end

    # def create
    #   @manifest.save
    #   @application.save
    # end

  end
end