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
      @path = path || File.expand_path(Dir.pwd)
      @target = File.join(path,options.fetch('destination'))

      empty_directory @target unless Dir.exist?(@target)

      builder_options = {
        :ex_dir => path,
        :verbose => false,
        :ignorefile => /\.swp/,
        :ignoredir => /\.(?:svn|git|cvs)/
      }

      builder_options[:pkey_output] = pkey_path
      builder_options[:pkey] = existed_pkey if existed_pkey
      builder_options.merge!(output)

      build_extension(builder_options)
    end

    private

    # return output path based on options[:format]
    # {:crx_output => path} or {:zip_output => path}
    def output
      hash = Hash.new
      key = :"#{format}_output"
      hash[key] = File.join(@target,name_format)
      hash
    end

    def name
      Pathname.new(@path).basename
    end

    def format
      options.fetch('format')
    end

    def name_format
      "#{name}.#{format}"
    end

    def existed_pkey
      Dir.glob(File.join(@target,'*.pem')).first
    end

    def pkey_path
      File.join(@target,"#{name}.pem")
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

    def path_for(file)
      raise "@target is not set" unless @target
      File.join(@target,file)
    end
  end
end