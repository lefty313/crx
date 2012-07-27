require 'spec_helper'

describe Crx::Command do

  it { should respond_to :add }
  it { should respond_to :create_folder }
  # it { should respond_to :pack }
  # it { should respond_to :install }
  # it { should respond_to :new }

  # it 'should create folder' do
  #   subject.create_folder 'my_new_extension'
  #   Dir.exists?('my_new_extension').should be_true
  # end

  it 'should create manifest' do
    subject.add 'manifest'
    File.exists?('manifest.json').should be_true
  end

  it 'should raise error with wrong name' do
    expect { subject.add 'manifest.json'}.to raise_error(ArgumentError) 
  end

  # xit 'should add content_script' do
  #   Crx::ContentScript.should_receive(:new).and_return(true)
  #   subject.add :content_script, {}
  # end

  # xit 'should add background_script' do
  #   Crx::ContentScript.should_receive(:new).and_return(true)
  #   subject.add :content_script, {}
  # end

end