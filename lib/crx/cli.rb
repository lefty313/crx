require 'thor'
require 'crx'
require 'pry'

# https://github.com/wycats/thor/blob/master/spec/actions/file_manipulation_spec.rb
# http://rdoc.info/github/wycats/thor/master/Thor/Actions#template-instance_method

module Crx
  class Cli < Thor
    include Thor::Actions

    def self.source_root
      File.join(Crx::Rootpath, 'crx/templates')
    end

    # method_option :mode, aliases: '-m', desc: 'extension ui type', default: 'browser'
    desc "new", "create new chrome plugin"
    def new(name)
      target = File.join(Dir.pwd, name)

      empty_directory target
      template 'manifest.json', File.join(target,'manifest.json')
      template 'popup.html', File.join(target,'popup.html')
      template 'popup.js', File.join(target,'popup.js')

      copy_file 'icon.png', File.join(target,'icon.png')
    end

    method_option :chrome_path, desc: 'path to chrome browser bin'
    desc "load", "load extension to chrome"
    def load(path)
      path = File.expand_path(path)
      Kernel.system("#{chrome} --load-extension=#{path}")
    end

    private

    def chrome
      name = options[:chrome_path] || 'chromium-browser'
      `which #{name}`.chomp
    end
  end
end