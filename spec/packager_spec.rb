require 'spec_helper'

describe Gem::Repackager do
  let(:gem_dir) { 
    File.expand_path File.dirname(__FILE__) + '/../support'
  }
  let(:destination_dir) {
    File.expand_path File.dirname(__FILE__) + '/../support/built'
  }
  subject { Gem::Repackager.new gem_dir }
  let(:packager) { subject }

  its(:gem_dir) { should == gem_dir }

  before do
    packager.silence_warnings
  end

  describe '#package_all' do
    it 'detects all specs in the spec dir' do
      packager.stub(:package_gem) { false }
      packager.should_receive(:load_spec).exactly(5).times
      packager.package_all
    end

    it 'calls package_gem for each spec loaded' do
      packager.should_receive(:package_gem).exactly(5).times
      packager.package_all
    end

    it 'adds the gem to gems_built if successfully packaged' do
      packager.should_receive(:package_gem).exactly(5).times { "gem" }
      FileUtils.stub(:mv)
      packager.package_all
      packager.gems_built.should have(5).gems
    end

    it 'should move the gem to the default directory' do
      packager.should_receive(:package_gem).exactly(5).times { "gem" }
      FileUtils.should_receive(:mv).with("gem", packager.gem_dir).exactly(5).times
      packager.package_all
    end

    it 'should move the gem to a custom directory if passed' do
      packager.should_receive(:package_gem).exactly(5).times { "gem" }
      FileUtils.should_receive(:mv).with("gem", destination_dir).exactly(5).times
      packager.package_all destination_dir
    end
  end

  describe '#package_gem' do
    let(:spec_file) { gem_dir + "/specifications/rspec-2.11.0.gemspec" }
    let(:spec) { Gem::Specification.load spec_file }

    it 'returns the gem filename if packaging was successful' do
      result = packager.package_gem spec
      result.should == 'rspec-2.11.0.gem'
      FileUtils.rm_rf('rspec-2.11.0.gem')
    end

    it 'returns nil if packaging was unsuccessful' do
      Gem::Builder.any_instance.should_receive(:build) { nil }
      result = packager.package_gem spec
      result.should be_nil
    end

    it 'changes to the gem directory' do
      Gem::Builder.any_instance.should_receive(:build) { nil }
      packager.should_receive(:enter_gem_directory).with('rspec-2.11.0')
      packager.package_gem spec
    end

    it 'symlinks the bin directory' do
      Gem::Builder.any_instance.should_receive(:build) { nil }
      packager.should_receive(:symlink_bin)
      packager.package_gem spec
    end

    it 'removes the bin directory after building' do
      Gem::Builder.any_instance.should_receive(:build) { nil }
      packager.should_receive(:unlink_bin)
      packager.package_gem spec
    end
  end

  describe '#load_spec' do
    let(:spec_file) { gem_dir + "/specifications/rspec-2.11.0.gemspec" }

    context 'passing gem name and version' do
      it 'converts name and version to gemspec filename' do
        Gem::Specification.should_receive(:load).with(spec_file)
        spec = packager.load_spec name: 'rspec', version: '2.11.0'
      end

      it 'returns a Gem::Specification' do
        spec = packager.load_spec name: 'rspec', version: '2.11.0'
        spec.should be_instance_of Gem::Specification
        spec.file_name.should == 'rspec-2.11.0.gem'
      end
    end

    context 'passing gemspec filename' do
      it 'returns a Gem::Specification' do
        spec = packager.load_spec filename: spec_file
        spec.should be_instance_of Gem::Specification
        spec.file_name.should == 'rspec-2.11.0.gem'
      end
    end
  end

  describe '#enter_gem_directory' do
    it 'should change directory to gem directory' do
      FileUtils.should_receive(:cd).with("#{gem_dir}/gems/rspec-2.11.0")
      packager.enter_gem_directory 'rspec-2.11.0'
    end
  end

  describe '#symlink_bin' do
    it 'should create a symlink to the bin directory inside the gem directory' do
      FileUtils.should_receive(:ln_sf).with('../../bin', 'bin')
      packager.symlink_bin
    end
  end

  describe '#unlink_bin' do
    it 'should remove the symlink to the bin dir' do
      FileUtils.should_receive(:rm_f).with('bin')
      packager.unlink_bin
    end
  end
end
