require 'spec_helper'

describe Crx::Options::Build do
  subject { Crx::Options::Build.new(path,options) }

  let(:path)    { Pathname.new('path/to/my/extension').expand_path }
  let(:target)  { path.join('custom_build') }
  let(:name)    { path.basename }
  let(:options) { @options }
  before do
    @options = {
      'destination' => 'custom_build',
      'format' => 'crx'
    }
  end

  context "with path" do
    it 'should expand given path' do
      subject.path.to_s.should == path.to_s
    end
  end

  context "without path" do
    let(:path) { nil }

    it 'should use actual user directory as path' do
      subject.path.to_s.should == File.expand_path(Dir.pwd)
    end
  end

  context "when it's valid" do
    let(:builder_options) do
      {
        ex_dir: path.join('app').to_s,
        pkey_output: target.join("#{name}.pem").to_s,
        verbose: false,
        ignorefile: /\.swp/,
        ignoredir: /\.(?:svn|git|cvs)/
      }
    end

    it 'should return target based on path and passed destination' do
      subject.target.to_s.should == path.join(options['destination']).to_s
    end

    it 'should return name based on path' do
      subject.name.should == name.to_s
    end

    it 'should return options for crx builder' do
      options['format'] = 'crx'

      expected_options = builder_options.merge({
        crx_output: target.join("#{name}.crx").to_s,
      })
      subject.for_builder.should == expected_options
      subject.package.should == target.join("#{name}.crx")
    end

    it 'should return options for zip builder' do
      options['format'] = 'zip'

      expected_options = builder_options.merge({
        zip_output: target.join("#{name}.zip").to_s
      })
      subject.for_builder.should == expected_options
      subject.package.should == target.join("#{name}.zip")
    end

    it 'should return pkey path if exist' do
      existed_pkey = target.join("#{name}.pem").to_s
      stub_pkey(existed_pkey)

      subject.for_builder[:pkey].should == existed_pkey
    end

    it 'should not return pkey if it not exist' do
      subject.for_builder[:pkey].should be_nil
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

    it 'without format' do
      options['format'] = nil

      subject.valid?.should be_false
      subject.errors.messages.should == {format: ["you can use only [crx,zip]"]}
    end
  end

  def stub_pkey(path)
    Dir.stub(:glob).and_return([path])
  end

end