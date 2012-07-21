require 'spec_helper'

describe Crx::Plugin do

  context "creating" do
    subject { Crx::Plugin.new(name: 'my_new_plugin', description: 'my random description') }

    its(:name) { should == "my_new_plugin" }
    its(:version) { should == "0.0.1" }
    its(:description) { should == "my random description"}

    it 'should create manifest.yml' do
      subject.save_manifest
      File.exist?("manifest.yml").should be_true
    end

  end

end