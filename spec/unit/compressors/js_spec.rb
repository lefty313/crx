require 'spec_helper'
require 'uglifier'

describe Crx::Compressors::Js do
  let(:source)  { 'assets/javascript' }
  let(:options) { Hash.new }

  it 'should compres javascript files' do
    Uglifier.should_receive(:compile).with(source, options)
    subject.compress(source, options)
  end
end