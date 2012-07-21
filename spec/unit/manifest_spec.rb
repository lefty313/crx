require 'spec_helper'
require 'yaml'

describe Crx::Manifest do
  subject { Crx::Manifest.new(manifest) }

  it 'should dump to yml' do
    subject.should_receive(:to_yaml).and_return(manifest.to_yaml)
    subject.to_yaml
  end

  private

    def manifest
      @manifest ||= {
        name: 'my extension',
        description: 'my description',
        version: '0.0.2'
      }
    end

end