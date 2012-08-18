require 'spec_helper'

describe Crx::Cli do
  # let(:directory) { 'my_awesome_plugin' }

  context "crx new" do
    let(:dir_name) {'example_plugin'}

    it 'should create plugin files' do
      expected_files = ['manifest.json','popup.html','popup.js','icon.png']

      command :new, dir_name
      dir_name.should have_files(expected_files)
    end
  end

  context "crx load" do
    let(:path) { File.join(Dir.pwd,'test_plugin') }
    
    it 'should load extension to chrome' do
      path_to_chrome = "/usr/bin/chromium-browser"

      subject.stub(:chrome).and_return(path_to_chrome)
      Kernel.should_receive(:system).with("#{path_to_chrome} --load-extension=#{path}")
      command :load, path
    end    
  end

  private

  def command(name,*args)
    subject.class.start([name.to_s,*args])
  end

end