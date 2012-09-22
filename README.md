# Gem::Repackager

Have you ever been without internet and needed a gem but it's in the wrong RVM gemset?
How about attempting to correct a problem with a production environment and need to
clone the exact gems available?  Perhaps you are attempting a full app stack backup
for compliance purposes?

Gem::Repackager packages one or more of your installed gems back into .gem files for
easy transportation.  Gem::Repackager comes with a command-line utility to facilitate,
with easy extensibility in the code as well.

## Installation

It's a gem, so install it. 'gem install gem\_repackager' or add it to bundler.

## Usage

The command-line utlity is as follows:

`gem_repackager all|GEM-VERSION[,GEM-VERSION,...] DIRECTORY [destination=GEM_FILE_DESTINATION]`

Specifying `all` in the first parameter tells `gem_repackager` to build all gems found 
in the target directory. Alternatively, passing a comma-separated list of gems
and their versions will build just those gems.

`DIRECTORY` refers to the location of your installed directories.  Note that this is
the directory that contains `specifications`, `bin`, `gems`, etc, and not the `gems`
directory itself. In RVM, this is usually along the lines of `~/.rvm/gems/GEMSET` or
simply `$GEM_HOME`.

By default, `gem_repackager` places the packaged gems into `DIRECTORY`. To change
this, pass the `destination` parameter and the resulting gems will be moved there.

Here's an example of packaging all gems in my current RVM gemset to a custom directory:

`gem_repackager all $GEM_HOME destination=~/gem_export`

And here is how you would package all of the rspec 2.11.0 gems to the default directory:

`gem_repackager rspec-2.11.0,rspec-core-2.11.0,rspec-expectations-2.11.2,rspec-mocks-2.11-1 $GEM_HOME`

## Contributing

Pull requests welcome, preferably with tests because I am lazy and do not want to run
every command to make sure changes did not break anything.

## Author

Written by [Andrew 'Cad' Nordman](https://github.com/cadwallion) thanks to not having
any internet access for a week and needing to get things done.
