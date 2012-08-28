require 'spec_helper'

describe Crx::Options::New do
  subject { Crx::Options::New.new(name,options)}
  let(:name) { 'my_extension' }
  let(:file) { Crx::Options::FileContainer }

  context "wrong type" do
    let(:options) { {'type' => 'invalid'} }

    it 'should not be valid' do
      subject.valid?.should be_false
      subject.errors.messages.should == {type: ["invalid is wrong type"]}
    end

    it 'validate! should raise exception' do
      expect {subject.validate!}.to raise_error(Crx::Options::ValidationError)
    end 
  end

  context "empty type" do
    let(:options) { {} }
    it 'should not be valid' do
      subject.valid?.should be_false
      subject.errors.messages.should == {type: ["can't be blank", " is wrong type"]}
    end
  end

  context "type == page_action" do
    let(:options) { {'type' => 'page_action'} }

    it 'should return directories to copy' do
      expected_directories = [
        'defaults',
        'page_action'
      ]
      subject.directories.should == expected_directories
    end
  end

  context "type == browser_action" do
    let(:options) { {'type' => 'browser_action'} }

    it 'should return directories to copy' do
      expected_directories = [
        'defaults',
        'browser_action'
      ]
      subject.directories.should == expected_directories
    end
  end
end