# require 'spec_helper'
# require 'yaml'

# describe Crx::Manifest do
#   subject { Crx::Manifest.new(manifest) }

#   it 'should save with proper content' do
#     subject.save
#     File.read("manifest.json").should match(manifest.to_json)
#   end

#   private

#     def manifest
#       @manifest ||= {
#         name: 'my extension',
#         description: 'my description',
#         version: '0.0.2'
#       }
#     end

# end