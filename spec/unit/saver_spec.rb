require 'spec_helper'

class Saveable
  include Crx::Saver

  save_object :@object_to_save, path: 'file.json'

  def initialize
    @object_to_save = {hello: 'world'}
  end

end

# save_object :opt, convert: :to_json, path: 'manifest.yml', force: true

describe Crx::Saver do
  subject { Saveable.new }

  let(:path) { 'file.json'}
  let(:content) { {hello: 'world'} }

  it { should respond_to(:save)}

  it 'should save file with good content' do
    subject.save
    File.read(path).should match(content.to_json)
  end

  it 'should save to nested path' do 
    subject.save_path = 'very/nested/second_path.json'
    subject.save
    File.read('very/nested/second_path.json')
  end

  it 'should change path' do
    subject.save_path = 'very/nested/second_path.json'
    subject.save_path.should == 'very/nested/second_path.json'
  end

  it 'should change convert method' do
    subject.convert_to = :big_boobs
    subject.convert_to.should == :big_boobs 
  end

  # it 'should raise NotImplementedError if class not respond to file' do
  #   expect { subject.file }.to raise_error( NotImplementedError )
  # end

  # it 'should not raise NotImplemented error if class respond to file' do
  #   subject.stub(:file).and_return(content)
  #   subject.file.should == content
  # end

  # it 'should raise NotImplementedError if class not respond to path' do
  #   expect { subject.path }.to raise_error( NotImplementedError )
  # end

  # it 'should not raise NotImplemented error if class respond to path' do
  #   subject.stub(:path).and_return(path)
  #   subject.path.should == path
  # end
end