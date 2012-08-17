require 'spec_helper'

describe Crx::Cli do
  let(:directory) { 'my_awesome_plugin' }

  it { should respond_to :new }

  it 'should create browser plugin' do
    expected_files = ['manifest.json','popup.html','popup.js','icon.png']

    command :new, directory
    directory.should have_files(expected_files)
  end

  private

  def command(name,*args)
    options = args.extract_options!
    subject.invoke name, args, options
  end

end