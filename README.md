# History::Client
Provides a Ruby client to interact with the [History Service](https://git-aws.internal.justin.tv/foundation/history-service).

# Installation

Add this line to your application's Gemfile:

```ruby
gem 'history-client'
```

And then run:

    $ bundle install

# Usage

Please see our [usage guidelines](https://git-aws.internal.justin.tv/foundation/history-client-ruby/blob/master/doc/usage.md).

# Testing
Run tests with `bundle exec rspec spec`.

# Release

1. Bump `./lib/history/version.rb`.
2. Merge into `master`. This will trigger an autodeploy to artifactory.
