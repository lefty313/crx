require 'thor'
require 'crx'
require 'pry'
require 'crxmake'

# https://github.com/wycats/thor/blob/master/spec/actions/file_manipulation_spec.rb
# http://rdoc.info/github/wycats/thor/master/Thor/Actions#template-instance_method

module Crx
  class Cli < Thor
    include Thor::Actions

    def self.source_root
      File.join(Crx::Rootpath, 'crx/templates')
    end

    method_option :type, desc: "extension type [popup]", default: "popup"
    desc "new  [NAME]", "create new chrome plugin"
    def new(name)
      opt = Options::New.new(name, options)
      opt.validate!

      empty_directory opt.target
      apply_templates opt.templates
      copy_files      opt.files
    end

    method_option :chrome_path, desc: 'path to chrome browser bin', default: 'chromium-browser'
    desc "load [PATH]", "load extension to chrome"
    def load(path)
      path = File.expand_path(path)
      run("#{chrome} --load-extension=#{path}")
    end

    method_option :format, desc: 'extension build format: [zip,crx]', default: 'crx'
    method_option :destination, desc: 'folder name for extension build', default: 'build'
    desc "build [PATH]", "build crx package"
    def build(path=nil)
      opt = Options::Build.new(path, options)
      opt.validate!

      empty_directory opt.target unless Dir.exist?(opt.target)
      build_extension opt.for_builder
    end

    private

    def build_extension(opts)
      if opts[:crx_output]
        CrxMake.make(opts)
      else
        CrxMake.zip(opts)
      end
    end

    def chrome
      `which #{options[:chrome_path]}`.chomp
    end
  end
end