require 'spec_helper'

describe Crx::Options::Build do
	subject { Crx::Options::Build.new(path,options) }

	let(:path) { 'path/to/my/extension' }
	let(:options) { @options }
	before do
		@options = {
			'destination' => 'custom_build',
			'format' => 'crx'
		}
	end

	context "with path" do
		it 'should expand given path' do
			subject.path.should == File.expand_path(path)
		end
	end

	context "without path" do
		let(:path) { nil }

		it 'should use actual user directory as path' do
			subject.path.should == File.expand_path(Dir.pwd)
		end
	end

	context "when it's valid" do
		let(:builder_options) do
			{
        ex_dir: subject.path,
        pkey_output: File.join(subject.target,"#{subject.name}.pem"),
        verbose: false,
        ignorefile: /\.swp/,
        ignoredir: /\.(?:svn|git|cvs)/
			}
		end

		it 'should return target based on path and passed destination' do
			subject.target.should == File.join(subject.path,options['destination'])
		end

		it 'should return name based on path' do
			subject.name.should == Pathname.new(path).basename.to_s
		end

		it 'should return options for crx builder' do
			options['format'] = 'crx'

			expected_options = builder_options.merge({
        crx_output: File.join(subject.target,"#{subject.name}.crx"),
			})
			subject.for_builder.should == expected_options
		end

		it 'should return options for zip builder' do
			options['format'] = 'zip'

			expected_options = builder_options.merge({
				zip_output: File.join(subject.target,"#{subject.name}.zip")
			})
			subject.for_builder.should == expected_options
		end

		it 'should be valid' do
			subject.valid?.should be_true
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

end