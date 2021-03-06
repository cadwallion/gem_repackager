require 'gem_repackager/version'

module Gem
  module UserInteraction
    def silent_alert_warning(*) ; end
  end

  # Repackages one or more installed gems back into a .gem file
  #
  # When a gem is installed, the file is split into multiple directories. The
  # gemspec is placed in the specifications directory, the executables are
  # placed in the bin directory, and the rest of the code is placed in a named
  # directory within the gems directory.
  #
  # Gem::Repackager repackages gems back into .gem file(s), either individually
  # or a directory at a time.
  #
  #   packager = Gem::Repackager.new '/opt/ruby/gems'
  #   packager.package_all '~/gems'
  #
  #   spec = packager.load_spec 'activemodel', '3.2.8'
  #   packager.package_gem spec
  # 
  # Gem::Repackager requires a path to the gems directory of the desired Ruby
  # installation in order to detect specs and properly recombine all the parts
  # of a gem.  It defaults to the current working directory.
  class Repackager
    attr_reader :gems_built, :gems_failed, :gem_dir

    def initialize gem_dir = '.'
      @gem_dir = gem_dir
    end

    # Builds all gems and moves to determined directory
    #
    # @param [String] Destination of built gems. Defaults to gem directory
    # @return [Array] List of all gems built successfully
    def package_all destination = gem_dir
      @gems_built = []
      @gems_failed = []

      Dir["#{@gem_dir}/specifications/*.gemspec"].each do |spec_filename|
        spec = load_spec filename: spec_filename
        gem = package_gem spec

        if gem
          @gems_built.push gem
          FileUtils.mv gem, destination
        else
          @gems_failed.push spec_filename
        end
      end

      @gems_built
    end

    # Packages gem from Gem::Specification. If successful, returns the
    # filename of the gem packaged. If unsuccessul, returns nil.
    #
    # @param [Gem::Specification] Gemspec to build
    # @return [String,nil] Filename of gem built, or nil
    def package_gem spec
      enter_gem_directory spec.file_name.sub(/\.gem/,'')
      symlink_bin
      Gem::Builder.new(spec).build
    rescue Gem::InvalidSpecificationException
      return nil
    ensure
      unlink_bin
    end

    # Enters gems directory and loads the .gemspec
    #
    # @param [String] filename (.gemspec) of gem
    # @return [Gem::Specification] parsed .gemspec
    def load_spec options = {}
      if options[:filename]
        filename = options[:filename]
      elsif options[:name] && options[:version]
        filename = "#{@gem_dir}/specifications/#{options[:name]}-#{options[:version]}.gemspec"
      end

      Gem::Specification.load filename
    end

    # Enters specific gem's directory within gems dir
    #
    # @param [String] name of the gem
    def enter_gem_directory gem
      FileUtils.cd "#{@gem_dir}/gems/#{gem}"
    end

    # Symlink the bin directory to the gem directory. This is due
    # to the decomposed nature of installed gems compared to the
    # original conjoined structure of the gem before packaging.
    #
    # @see Gem::Repackager
    def symlink_bin
      FileUtils.ln_sf('../../bin', 'bin')
    end

    # Removes the symlink to the bin directory.
    #
    # @see #symlink_bin
    def unlink_bin
      FileUtils.rm_f('bin')
    end

    # Silences warning generated by validating and packaging gems
    #
    # When validating a gemspec before building, a slew of warnings and
    # success notifications are spewed into the console without an easy
    # way to silence the verbosity.  This shuts off the warnings and 
    # build success output in a reversible fashion
    def silence_warnings
      @verbose = Gem.configuration.verbose
      Gem.configuration.verbose = false # SILENCE
      Gem::UserInteraction.send :alias_method, :loud_alert_warning, :alert_warning
      Gem::UserInteraction.send :alias_method, :alert_warning, :silent_alert_warning
    end

    # Resets warnings to before their silenced state
    #
    # @see #silence_warnings
    def reset_warnings
      Gem.configuration.verbose = @verbose
      Gem::UserInteraction.send :alias_method, :silent_alert_warning, :alert_warning
      Gem::UserInteraction.send :alias_method, :alert_warning, :loud_alert_warning
    end
  end
end
