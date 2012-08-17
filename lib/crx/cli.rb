require 'thor'
require 'ostruct'

# https://github.com/wycats/thor/blob/master/spec/actions/file_manipulation_spec.rb
# http://rdoc.info/github/wycats/thor/master/Thor/Actions#template-instance_method

module Crx
  class Cli < Thor
    include Thor::Actions

    def self.source_root
      File.join(Crx::Rootpath, 'crx/templates')
    end

    # method_option :mode, aliases: '-m', desc: 'extension ui type', default: 'browser'
    desc "create_folder", "create main extension directory"
    def new(name)
      target = File.join(Dir.pwd, name)

      empty_directory target
      template 'manifest.json', File.join(target,'manifest.json')
      template 'popup.html', File.join(target,'popup.html')
      template 'popup.js', File.join(target,'popup.js')
    end

  end
end