require 'spec_helper'

describe Crx::Cli do

  before :each do
    Crx.remove_compiler
  end

  context "crx new" do
    let(:dir_name) {'example_plugin'}

    it 'should create plugin files' do
      expected_files = [
        'Gemfile',
        'app/manifest.json',
        'app/index.html',
        'app/images/icon.png',
        'app/javascripts/application.js',
        'app/stylesheets/application.css'
      ]


      in_temp_dir do
        command ['new', dir_name,'--bundle','false']
        dir_name.should have_files(expected_files)
      end 
    end
  end

  # context "crx load" do
  #   let(:path) { File.join(Dir.pwd,'test_plugin') }
    
  #   xit 'should load extension to chrome' do
  #     path_to_chrome = "/usr/bin/this_is_my_chrome_bin"

  #     subject.class.any_instance.stub(:chrome).and_return(path_to_chrome)
  #     Kernel.should_receive(:system).with("#{path_to_chrome} --load-extension=#{path}")
  #     command :load, path, chrome_path: path_to_chrome
  #   end    
  # end

  context "crx build" do
    let(:extension_name) {'my_awesome_extension'}
    let(:build_path)     {"#{extension_name}/build"}
    let(:app_path)       {"#{extension_name}/app"}

    it '--format=crx should build crx package' do
      expected_files = ['my_awesome_extension.crx',"#{extension_name}.pem"]

      in_temp_dir do
        create_app_dir(app_path)
        
        command ['build', extension_name, '--format','crx']
        build_path.should have_files(expected_files)
      end
    end

    it '--format=zip should build zip package' do
      expected_files = ["#{extension_name}.zip","#{extension_name}.pem"]

      in_temp_dir do
        create_app_dir(app_path)

        command ['build', extension_name, '--format', 'zip']
        build_path.should have_files(expected_files)
      end
    end
  end

  context "crx compile" do
    let(:path) { Pathname.new('my_extension') }
    let(:compile_path) { path.join('build/compile') }

    it 'should minimize assets when user want it' do
      compiler = mock.as_null_object
      compiler.should_receive(:compile_to).with(compile_path, minimize: true, merge: true)
      Crx.stub(:compiler).and_return(compiler)
      
      in_temp_dir do
        command ['compile', path.to_s, '--merge','true','--minimize','true']
      end
    end

    it 'should merge assets when user want it' do
      expected_files = [
        'application.js',
        'application.css',
        'icon.png',
        'manifest.json'
      ]


      in_temp_dir do
        create_app(path.to_s)

        command ['compile', path.to_s, '--merge','true','--minimize','false']
        compile_path.should have_files(expected_files)
      end

    end
  end

  private

  def command(args)
    capture(:stdout) { subject.class.start(args) }
  end

  def create_app(path)
    assets = path_to_fixture('app')
    FileUtils.mkdir_p path
    FileUtils.cp_r File.join(assets,"/."), path
  end

  def create_app_dir(dir)
    FileUtils.mkdir_p(dir)
  end

  def show_files(path)
    path = Pathname.new(path) unless path.respond_to?(:each_child)
    pp path.each_child.map(&:to_s)
  end
end 