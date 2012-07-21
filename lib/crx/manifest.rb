module Crx
  class Manifest
    include Crx::Saver

    save_object :@hash, path: 'manifest.json'

    def initialize(hash)
      @hash = hash
    end 

  end
end