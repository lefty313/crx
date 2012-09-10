require 'spec_helper'

class DummySprocketAsset
  def logical_path
    'javascript/index.js'
  end

  def write_to(path)
    f = File.new(path,"w")
    f.close
    path
  end
end

describe Crx::SprocketCompiler::Asset do
  subject { Crx::SprocketCompiler::Asset.new(asset) }
  let(:asset) { DummySprocketAsset.new }

  it 'save_to method should save self' do
    dir  = Pathname.new('my/assets/')
    path = "javascript/index.js"

    in_temp_dir do
      filename = subject.save_to(dir)

      filename.should == dir.join(path)
      filename.exist?.should be_true
    end
  end
end

describe Crx::SprocketCompiler do
  subject { Crx::SprocketCompiler.new(engine) }

  let(:engine) { stub("Sprockets::Environment") }
  let(:fake_assets) do
    [DummySprocketAsset.new, DummySprocketAsset.new]
  end

  it 'should append_path' do
    path = 'foo/bar/baz'

    engine.should_receive(:append_path).with(path)
    subject.append_path(path)
  end

  it 'should delete paths' do
    engine.should_receive(:clear_paths)
    subject.clear_paths
  end

  it 'should return assets' do
    subject.stub(:find_asset).and_return(fake_assets)

    subject.should have(2).assets
    subject.assets.each do |asset|
      asset.should be_instance_of Crx::SprocketCompiler::Asset
    end
  end

  it 'should use filter when defined' do
    filter =  [Proc.new { 'procfilter' },Regexp.new('regexpfilter')]
    subject.filter = filter
    subject.engine.should_receive(:each_logical_path).with(filter).and_return(Enumerator.new([]))

    subject.assets
  end

  it 'should use wildcard filter as default' do
    filter = //
    subject.engine.should_receive(:each_logical_path).with(filter).and_return(Enumerator.new([]))

    subject.assets
  end

 end