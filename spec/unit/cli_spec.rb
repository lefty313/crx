require 'spec_helper'

describe Crx::Cli do
  let(:directory) { 'my_awesome_plugin' }
  let(:path) { File.join(Dir.pwd,'test_plugin') }

  it { should respond_to :new }

  it 'should create browser plugin' do
    expected_files = ['manifest.json','popup.html','popup.js','icon.png']

    command :new, directory
    directory.should have_files(expected_files)
  end


  it 'should use user chrome to load extension' do
    path_to_chrome = "/usr/bin/chromium-browser"

    subject.stub(:chrome).and_return(path_to_chrome)
    Kernel.should_receive(:system).with("#{path_to_chrome} --load-extension=#{path}")

    command :load, path
  end

  private

  def command(name,*args)
    options = args.extract_options!
    subject.invoke name, args, options
  end

end