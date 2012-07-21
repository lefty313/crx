require 'spec_helper'

describe Crx::Plugin do

  context "creating" do
    subject { Crx::Plugin.new('my_new_plugin') }

    its(:title) { should == "my_new_plugin" }
  end

end