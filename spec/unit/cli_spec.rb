require 'spec_helper'

describe Crx::Cli do
  context "crx new" do
    let(:dir_name) {'example_plugin'}

    it 'should create plugin files' do
      expected_files = ['manifest.json','index.html','index.js','icon.png']

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
    let(:build_path) {"#{extension_name}/build"}

    it '--format=crx should build crx package' do
      expected_files = ['my_awesome_extension.crx',"#{extension_name}.pem"]

      in_temp_dir do
        command ['build', extension_name, '--format','crx']
        build_path.should have_files(expected_files)
      end
    end

    it '--format=zip should build zip package' do
      expected_files = ["#{extension_name}.zip","#{extension_name}.pem"]

      in_temp_dir do
        command ['build', extension_name, '--format', 'zip']
        build_path.should have_files(expected_files)
      end
    end

    xit 'should use old pem key if exist in directory' do
      # create_pkey
      # command ['build', extension_name]
    end
  end

  private

  def command(args)
    capture(:stdout) { subject.class.start(args) }
  end

  def create_pkey
    Dir.stub(:glob).and_return([existed_pkey])
  end
end