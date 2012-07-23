require 'spec_helper'

module Foo
  module Bar
  end
end

describe String do

  it 'should classify string' do
    "foo".classify.should == "Foo" 
  end

  it 'should classify two part string' do
    "foo_bar".classify.should == "FooBar"
  end

  it 'should contantize string string' do
    "Foo".constantize.should == Foo
  end

  it 'should contantize two part string string' do
    "Foo::Bar".constantize.should == Foo::Bar
  end

end