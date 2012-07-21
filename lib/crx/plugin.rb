module Crx
  class Plugin < Struct.new(:opts)

    attr_accessor :name, :description, :version

    def initialize(opts)
      self.name = opts[:name]
      self.description = opts[:description]
      self.version = opts[:version] || "0.0.1"
    end

  end
end