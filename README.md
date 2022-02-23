# ClusterID
TODO: Delete this and the text above, and describe your gem


## What's in the Box?
TODO: Write this.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'clusterid'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install clusterid


## Usage

TODO: Write usage instructions here


## Contributing

### Development
To get started development on this gem run the `bin/setup` command. This will install dependencies and run the tests and linting tasks to ensure everything is working.

For an interactive console with the gem loaded run `bin/console`.


### Testing
Use the `bundle exec rake test` command to run unit tests. To install the gem onto your local machine for general integration testing use `bundle exec rake install`.

To test the gem against each supported version of Ruby use `bin/test_versions`. This will create a Docker image for each version and run the tests and linting steps.


### Releasing
Do the following to release a new version of this gem:

- Update the version number in [lib/clusterid/version.rb](./lib/clusterid/version.rb)
- Ensure necessary documentation changes are complete
- Ensure changes are in the [CHANGELOG.md](./CHANGELOG.md)
- Create the new release using `bundle exec rake release`

After this is done the following side-effects should be visible:

- A new git tag for the version number should exist
- Commits for the new version should be pushed to GitHub
- The new gem should be available on [rubygems.org](https://rubygems.org).

Finally, update the documentation hosted on GitHub Pages:

- Check-out the `gh-pages` branch
- Merge `main` into the `gh-pages` branch
- Generate the documentation with `bundle exec rake yard`
- Commit the documentation on the `gh-pages` branch
- Push the new documentation so GitHub Pages can deploy it
