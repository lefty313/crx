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
    desc "new  [NAME]", "create new chrome plugin"
    def new(name)
      @target = File.join(Dir.pwd, name)
      empty_directory @target

      template  'manifest.json', path_for('manifest.json')
      template  'popup.html',    path_for('popup.html')
      template  'popup.js',      path_for('popup.js')
      copy_file 'icon.png',      path_for('icon.png')
    end

    method_option :chrome_path, desc: 'path to chrome browser bin', default: 'chromium-browser'
    desc "load [PATH]", "load extension to chrome"
    def load(path)
      path = File.expand_path(path)
      execute("#{chrome} --load-extension=#{path}")
    end

    private

    def chrome
      `which #{options[:chrome_path]}`.chomp
    end

    def execute(command)
      Kernel.system(command)
    end

    def path_for(file)
      raise "@target is not set" unless @target
      File.join(@target,file)
    end
  end
end