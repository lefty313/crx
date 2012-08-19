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

    class FileContainer < Struct.new(:from,:to)
    end

    class NewArgument
      attr_accessor :name, :options

      def initialize(name, options)
        self.name = name
        self.options = options
      end

      def target
        File.join(Dir.pwd,name)
      end

      def templates
        files = ['manifest.json','index.html','index.js']
        files = files.map do |file|
          FileContainer.new(File.join(type,file),File.join(target,file))
        end
      end

      def files
        files = ['icon.png']
        files = files.map do |file|
          FileContainer.new(File.join(type,file),File.join(target,file))
        end
      end

      def mode
        options[:mode]
      end

      private

      def type
        supported_types = ['popup']
        raise "#{mode} is not correct. Only #{supported_types}" unless supported_types.include?(mode)
        mode   
      end

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