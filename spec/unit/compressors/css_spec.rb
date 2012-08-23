require 'spec_helper'
require 'yui/compressor'

describe Crx::Compressors::Css do
  let(:source)  { 'assets/javascript' }
  let(:options) { Hash.new }

  it 'should compress css files' do
    engine = mock
    engine.should_receive(:compress).with(source)
    YUI::CssCompressor.should_receive(:new).with(options).and_return(engine)

    subject.compress(source, options)
  end
end