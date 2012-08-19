require 'spec_helper'

describe Crx::Options::New do
  subject { Crx::Options::New.new(name,options)}
  let(:name) { 'my_extension' }
  let(:file) { Crx::Options::FileContainer }

  context "wrong type" do
    let(:options) { {'type' => 'invalid'} }

    it 'should not be valid with wrong type' do
      subject.valid?.should be_false
      subject.errors.messages.should == {type: ["invalid is wrong type"]}
    end
  end

  context "empty type" do
    let(:options) { {} }
    it 'should not be valid without type' do
      subject.valid?.should be_false
      subject.errors.messages.should == {type: ["can't be blank", " is wrong type"]}
    end
  end

  context "type == popup" do
    let(:options) { {'type' => 'popup'} }
  
    it 'should return target based on name' do
      subject.target.should == File.join(Dir.pwd,name)
    end

    it 'should return template files' do
      files = [
        file.new("popup/manifest.json",File.join(subject.target,'manifest.json')),
        file.new("popup/index.html",File.join(subject.target,'index.html')),
        file.new("popup/index.js",File.join(subject.target,'index.js')),
      ]
      subject.templates.should == files
    end

    it 'should return files to copy' do
      files = [
        file.new("popup/icon.png",File.join(subject.target,'icon.png'))
      ]
      subject.files.should == files
    end
  end
end