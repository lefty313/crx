require 'spec_helper'

describe Crx::Cli do
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
        command ['new', dir_name]
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

  context "crx compile", slow: true do
    # let(:path) { 'path/to/not_compiled_extension'}

    it 'should compile assets from given path' do
      expected_files = [
        'build/compiled/javascripts/application.js',
        'build/compiled/stylesheets/application.css',
        'build/compiled/images/icon.png',
        'build/compiled/manifest.json',
      ]

      in_temp_dir do
        path = Dir.pwd
        create_assets

        command ['compile', path]
        path.should have_files(expected_files)

      end  
    end
  end

  private

  def command(args)
    capture(:stdout) { subject.class.start(args) }
  end

  def create_assets
    assets = path_to_fixture('app')
    FileUtils.cp_r File.join(assets,"/."), Dir.pwd
  end

  def create_app_dir(dir)
    FileUtils.mkdir_p(dir)
  end
end