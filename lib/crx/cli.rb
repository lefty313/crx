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
    method_option :bundle, type: :boolean, default: true, desc: "run bundle install"
    desc "new  [NAME]", "create new chrome plugin"
    def new(name)
      opt = Options::New.new(name, options)
      opt.validate!

      opt.directories.each do |dir|
        directory dir, opt.name
      end
      bundle_install(File.join(name,'Gemfile')) if options[:bundle]
    end

    method_option :chrome_path, desc: 'path to chrome browser bin', default: 'chromium-browser'
    desc "load [PATH]", "load extension to chrome"
    def load(path)
      path = File.expand_path(path)
      run("#{chrome} --load-extension=#{path}")
    end

    method_option :format, desc: 'extension build format: [zip,crx]', default: 'crx'
    method_option :destination, desc: 'folder name for extension build', default: Crx.config.build_path
    desc "build [PATH]", "build crx package"
    def build(path=nil)
      opt = Options::Build.new(path, options)
      opt.validate!

      empty_directory opt.target unless Dir.exist?(opt.target)
      invoke :compile, [path], []

      say_relative_path('build',opt.package)
      
      build_extension opt.for_builder
    end
    
    method_option :destination, default: Crx.config.compile_path, desc: 'folder name for compiled extension'
    method_option :minimize, type: :boolean, default: Crx.config.minimize, desc: 'minimization'
    method_option :merge, type: :boolean, default: Crx.config.merge, desc: 'concatenation assets to single file'
    desc "compile [PATH]", "compile extension"
    def compile(path=nil)
      path = Pathname.new(path || Dir.pwd)
      target = path.join(options[:destination]) 

      clean_or_create_directory(target)
      Crx.config.assets_paths.each { |path| Crx.compiler.add_path(path) }

      say_relative_path('compile',target)
      Crx.compiler.compile_to target, minimize: options[:minimize], merge: options[:merge]
    end

    private

    def bundle_install(gemfile)
      system("bundle install --gemfile=#{gemfile}")
    end

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