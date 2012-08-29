require 'spec_helper'

describe Crx::Options::Compile do
  subject       { Crx::Options::Compile.new(path,options)}
  let(:path)    { Pathname.new('path/to/my/extension').expand_path }
  let(:target)  { path.join('custom_build') }
  let(:name)    { path.basename }
  let(:options) { @options }
  before do
    @options = {
      'destination' => 'custom_build',
      'minimize' => false
    }
  end

  context "with path" do
    it 'should expand given path' do
      subject.path.to_s.should == path.join('app').to_s
    end
  end

  context "without path" do
    let(:path) { nil }

    it 'should use actual user directory as path' do
      subject.path.to_s.should == File.expand_path(File.join(Dir.pwd,'app'))
    end
  end

  context "when it's valid" do
    it 'should return target based on path and passed destination' do
      subject.target.to_s.should == path.join(options['destination']).to_s
    end

    it 'should return minimize option' do
      subject.minimize.should == @options['minimize']
    end

    it 'should return relative target' do
      subject.relative_target.should == target.relative_path_from(path)
    end

    it 'should be valid' do
      subject.valid?.should be_true
    end

    it 'validate! should not raise exception' do
      expect { subject.validate! }.not_to raise_error 
    end
  end

  context "when it's invalid" do
    it 'validate! should raise exception' do
      subject.stub(:valid?).and_return(false)
      expect {subject.validate!}.to raise_error(Crx::Options::ValidationError)
    end
  end

  context "should be invalid" do
    it 'without destination' do
      options['destination'] = nil

      subject.valid?.should be_false
      subject.errors.messages.should == {destination: ["can't be blank"]}
    end

    it 'without minimize' do
      options['minimize'] = :maybe

      subject.valid?.should be_false
      subject.errors.messages.should == {minimize: ["is not included in the list"]}
    end
  end
end