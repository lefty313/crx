require 'spec_helper'

describe Crx::Cli do

  context "crx new" do
    let(:dir_name) {'example_plugin'}

    it 'should create plugin files' do
      expected_files = ['manifest.json','popup.html','popup.js','icon.png']

      command ['new', dir_name]
      dir_name.should have_files(expected_files)
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

    before do
      @defaults = {
        ex_dir: extension_name,
        verbose: false,
        ignorefile:  /\.swp/,
        ignoredir: /\.(?:svn|git|cvs)/,
        pkey_output: pkey
      }
    end

    let(:extension_name) {'my_awesome_extension'}
    let(:build_path) {"#{extension_name}/build"}
    let(:crx_build) {"#{build_path}/#{extension_name}.crx"}
    let(:zip_build) {"#{build_path}/#{extension_name}.zip"}
    let(:pkey) {"#{build_path}/#{extension_name}.pem"}
    let(:existed_pkey) {"#{build_path}/my_random_named.pem"}

    it 'should build crx package as default' do
      opts = @defaults.merge({
        crx_output: crx_build
      })
      CrxMake.should_receive(:make).with(opts)
      command ['build', extension_name]
    end

    it 'should build zip package' do
      opts = @defaults.merge({
        zip_output: zip_build
      })
      CrxMake.should_receive(:zip).with(opts)
      command ['build', extension_name, '--format', 'zip']
    end

    it 'should use old pem key if exist in directory' do
      create_pkey
      opts = @defaults.merge({
        crx_output: crx_build,
        :pkey => existed_pkey
      })
      CrxMake.should_receive(:make).with(opts)
      command ['build', extension_name]
    end
  end

  private

  def command(args)
    # options = args.extract_options!
    # subject.invoke name, args, options
    subject.class.start args
  end

  def create_pkey
    Dir.stub(:glob).and_return([existed_pkey])
  end
end