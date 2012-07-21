describe Crx::Saver do
  subject { Object.new.extend(Crx::Saver)}

  let(:path) { 'my_awesome_path.yml'}
  let(:content) { {hello: 'world'} }

  it 'should raise NotImplementedError if class not respond to file' do
    expect { subject.file }.to raise_error( NotImplementedError )
  end

  it 'should not raise NotImplemented error if class respond to file' do
    subject.stub(:file).and_return(content)
    subject.file.should == content
  end

  it 'should raise NotImplementedError if class not respond to path' do
    expect { subject.path }.to raise_error( NotImplementedError )
  end

  it 'should not raise NotImplemented error if class respond to path' do
    subject.stub(:path).and_return(path)
    subject.path.should == path
  end


  it 'should save file with good content' do
    subject.stub(:file).and_return(content)
    subject.stub(:path).and_return(path)
    subject.save
    
    File.read(path).should match(content.to_yaml)
  end

end