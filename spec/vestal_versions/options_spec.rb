require 'spec_helper'

describe VestalVersions::Options do
  context 'with explicit configuration' do
    let(:options){ {:dependent => :destroy} }
    let(:prepared_options){ User.prepare_versioned_options(options.dup) }

    before do
      VestalVersions::Version.config.clear
      VestalVersions::Version.config.class_name = 'MyCustomVersion'
    end

    it 'has symbolized keys' do
      User.vestal_versions_options.keys.all?{|k| k.is_a?(Symbol) }
    end

    it 'combines class-level and global configuration options' do
      expect(prepared_options.slice(:dependent, :class_name)).to eq({
        :dependent  => :destroy,
        :class_name => 'MyCustomVersion'
      })
    end

  end

  context 'default configuration options' do
    subject { User.prepare_versioned_options({}) }

    it 'defaults to "VestalVersions::Version" for :class_name' do
      expect(subject[:class_name]).to eq('VestalVersions::Version')
    end

    it 'defaults to :delete_all for :dependent' do
      expect(subject[:dependent]).to eq(:delete_all)
    end

    it 'forces the :as option value to :versioned' do
      expect(subject[:as]).to eq(:versioned)
    end

    it 'defaults to [VestalVersions::Versions] for :extend' do
      expect(subject[:extend]).to eq([VestalVersions::Versions])
    end
  end
end
