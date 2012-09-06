require 'spec_helper'

class DummyEngine
  attr_accessor :paths, :js_compressor, :css_compressor, :filter
  attr_reader :assets

  def initialize
    self.paths  = Array.new
  end

  def append_path(path)
    paths << path
  end

  def assets(opt = {})
    @assets ||= begin 
      [
        DummyAsset.new(Object.new),
        DummyAsset.new(Object.new),
        DummyAsset.new(Object.new)
      ]
    end  
  end

end

class DummyAsset
  attr_reader :asset

  def initialize(asset)
    @asset    = asset
  end

  def save_to(path)
  end
end

describe Crx::Compiler do
  subject { Crx::Compiler.new(engine) }
  let(:engine)        { DummyEngine.new }
  let(:compiled_path) { 'compile/to/this/folder' }

  it 'add_path should add path to paths' do
    path1 = 'path/to/assets'
    path2 = 'path/to/another_assets'

    subject.add_path path1
    subject.add_path path2

    subject.paths.should == [path1, path2]
  end

  it 'compile_to should compile assets' do
    engine.assets.each {|a| a.should_receive(:save_to).with(compiled_path) }

    subject.compile_to(compiled_path)
  end

  it 'compile_to should merge assets' do
    subject.compile_to(compiled_path, merge: true)

    engine.filter.should == Crx.config.assets_filters
  end

  it 'compile_to should minimize assets' do
    subject.compile_to(compiled_path, minimize: true)

    engine.js_compressor.should be_instance_of Crx::Compressors::Js
    engine.css_compressor.should be_instance_of Crx::Compressors::Css
  end
end