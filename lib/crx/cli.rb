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

    method_option :type, desc: "extension type [browser_action, page_action]", default: "browser_action"
    desc "new  [NAME]", "create new chrome plugin"
    def new(name)
      opt = Options::New.new(name, options)
      opt.validate!

      opt.directories.each do |dir|
        directory dir, opt.name
      end
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

      invoke :compile, [path], []

      empty_directory opt.target unless Dir.exist?(opt.target)
      build_extension opt.for_builder
    end

    method_option :destination, desc: 'folder name for compiled extension', default: 'build/compiled'
    method_option :minimize, desc: 'minimization', type: :boolean, default: true
    desc "compile [PATH]", "compile extension"
    def compile(path=nil)
      opt = Options::Compile.new(path, options)
      opt.validate!

      remove_dir opt.target
      say_status('compile',"assets to #{opt.relative_target}", :green)

      Crx.compiler.add_path   opt.path
      Crx.compiler.compile_to opt.target, minimize: opt.minimize
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