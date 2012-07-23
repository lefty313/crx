require 'spec_helper'

describe Crx::Command do
  it { should respond_to :add }
  it { should respond_to :pack }
  it { should respond_to :install }
  it { should respond_to :new }

  it 'should add manifest' do
    Crx::Manifest.should_receive(:new).and_return(true)
    subject.add :manifest
  end

  xit 'should add content_script' do
    Crx::ContentScript.should_receive(:new).and_return(true)
    subject.add :content_script
  end

  xit 'should add background_script' do
    Crx::ContentScript.should_receive(:new).and_return(true)
    subject.add :content_script
  end

end