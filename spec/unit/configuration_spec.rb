require 'spec_helper'

describe Crx::config do
  describe "defaults" do
    it 'should return build path' do
      Crx.config.build_path.should == 'build'
    end

    it 'should return compile_path' do
      Crx.config.compile_path.should == 'build/compile'
    end

    it 'should return minimize option' do
      Crx.config.minimize.should be_true
    end

    it 'should return build format' do
      Crx.config.build_format.should == 'crx'
    end

    it 'should return assets_path' do
      expected_paths = [
        'app/javascripts',
        'app/stylesheets',
        'app/images',
        'app'
      ]

      Crx.config.assets_paths.should == expected_paths
    end

    it 'should return merge option' do
      Crx.config.merge.should be_false
    end

    it 'should return filters for sprockets minimization' do
      filters = Crx.config.assets_filters
      proc_filter = filters[0]
      regexp_filter = filters[1]

      proc_filter.call('foo.bar').should be_true
      proc_filter.call('abcd.js').should be_false
      proc_filter.call('foo.css').should be_false

      regexp_filter.should == /(?:\/|\\|\A)application\.(css|js)$/
    end
  end

  describe "custom" do
    before do
      Crx.configure do |config|
        config.minimize     = false
        config.build_path   = 'custom_build'
        config.compile_path = 'custom_compile'
        config.build_format = 'zip'
      end
    end

    it 'should change defaults' do
      Crx.config.minimize.should     == false
      Crx.config.build_path.should   == 'custom_build'
      Crx.config.compile_path.should == 'custom_compile'
      Crx.config.build_format.should == 'zip'
    end

    it 'should add path to assets_paths' do
      expected_paths = Crx.config.assets_paths + ['my/custom/path']

      Crx.config.assets_paths += ['my/custom/path']
      Crx.config.assets_paths.should == expected_paths
    end
  end
end