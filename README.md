# Gem::Repackager [![Build Status](https://secure.travis-ci.org/cadwallion/gem_repackager.png)](http://travis-ci.org/cadwallion/gem_repackager)

Have you ever been without internet and needed a gem but it's in the wrong RVM gemset?
How about attempting to correct a problem with a production environment and need to
clone the exact gems available?  Perhaps you are attempting a full app stack backup
for compliance purposes?

Gem::Repackager packages one or more of your installed gems back into .gem files for
easy transportation.  Gem::Repackager comes with a command-line utility to facilitate,
with easy extensibility in the code as well.

## Installation

It's a gem, so install it. `gem install gem_repackager` or add it to bundler.

## Usage

The command-line utility is as follows:

`gem_repackager DIRECTORY [options]`

This will repackage all gems in `DIRECTORY` and place the resulting .gem files in 
`DIRECTORY`. `DIRECTORY` refers to the location of your installed directories. Note 
that this is the directory that contains `specifications`, `bin`, `gems`, etc,
and not the `gems` directory itself. In RVM, this is usually along the lines of
`~/.rvm/gems/GEMSET` or simply `$GEM_HOME`.

By default, `gem_repackager` places the packaged gems into `DIRECTORY`. To change
this, pass the `--destination DIR` parameter and the resulting gems will be moved
there.

### Options

* `--gems gem-version[,gem-version,...]` - A comma-separated list of gems in "GEM-VERSION"
* `--destination DIR` - Location to store the packaged .gem files to. If this is not
passed, it will default to `DIRECTORY`
* `--[no]-verbose` - Toggle verbose mode. This includes Gem::Specification warnings,
so this could get noisy.

Here's an example of packaging all gems in my current RVM gemset to a custom directory:

`gem_repackager $GEM_HOME --destination=~/gem_export`

And here is how you would package all of the rspec 2.11.0 gems to the default directory:

`gem_repackager $GEM_HOME --gems rspec-2.11.0,rspec-core-2.11.0,rspec-expectations-2.11.2,rspec-mocks-2.11-1`

## Contributing

Pull requests welcome, preferably with tests because I am lazy and do not want to run
every command to make sure changes did not break anything.

## Author

Written by [Andrew 'Cad' Nordman](https://github.com/cadwallion) thanks to not having
any internet access for a week and needing to get things done.
