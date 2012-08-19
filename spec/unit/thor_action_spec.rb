require 'spec_helper'

describe Thor::Actions do
	subject do
		@object = Object.new
		@object.extend(Thor::Actions)
	end

	let(:file) { Struct.new(:from,:to) }

	it 'should copy files' do
		files_to_copy = [file.new('path1','path2'),file.new('path3','path4')]

		subject.should_receive(:copy_file).with('path1','path2').once
		subject.should_receive(:copy_file).with('path3','path4').once
		subject.copy_files(files_to_copy)
	end

	it 'should apply templates' do
		templates_to_apply = [file.new('path1','path2'),file.new('path3','path4')]

		subject.should_receive(:template).with('path1','path2').once
		subject.should_receive(:template).with('path3','path4').once		
		subject.apply_templates(templates_to_apply)
	end
end