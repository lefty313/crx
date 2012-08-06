require 'spec_helper'

describe Crx::Command do

  it { should respond_to :add }
  it { should respond_to :new }
  xit { should respond_to :pack }
  xit { should respond_to :install }
  xit { should respond_to :new }

  # it 'should create manifest' do
  #   command :add, 'manifest'
  #   File.read('manifest.json').should == fixture('manifest.json')
  # end

  # it 'should raise error with wrong name' do
  #   expect { command :add, 'wrong_name.txt'}.to raise_error(ArgumentError) 
  # end

  let(:directory) { 'my_awesome_plugin' }

  # it 'should create plugin directory' do
  #   command :new, plugin
  #   Dir.exists?(plugin).should be_true
  # end

  it 'should create browser plugin' do
    expected_files = ['manifest.json']

    command :new, directory
    directory.should have_files(expected_files)
  end

  # it 'should create page plugin' do
  #   command :new, 'plugin', mode: 'page'
  # end

  # xit 'should add content_script' do
  #   Crx::ContentScript.should_receive(:new).and_return(true)
  #   subject.add :content_script, {}
  # end

  # xit 'should add background_script' do
  #   Crx::ContentScript.should_receive(:new).and_return(true)
  #   subject.add :content_script, {}
  # end

  def command(name,*args)
    options = args.extract_options!
    subject.invoke name, args, options
  end

end