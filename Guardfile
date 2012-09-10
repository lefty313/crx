# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'rspec', :version => 2, :cli => '--color --format Fuubar' do
	notification :libnotify, :timeout => 2, :transient => false, :append => false, :urgency => :low
	watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/crx/(.+)\.rb$}) { |m| "spec/unit/#{m[1]}_spec.rb" }	
  watch(%r{^lib/crx/options/(.+)\.rb$}) { |m| "spec/unit/options/#{m[1]}_spec.rb" }	
  watch('spec/spec_helper.rb')  { "spec" }
end