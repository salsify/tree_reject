# tree_reject

[![Build Status](https://travis-ci.org/salsify/tree_reject.svg?branch=master)](https://travis-ci.org/salsify/tree_reject)


`tree_reject` is a Ruby gem that removes deeply nested keys from Ruby Hashes or hash-like objects.

For example if you have the Hash:

```ruby
hash = {
  a: {
    aa: {
      aaa: 'aaa',
      aab: 'aab'
    }
  },
  b: {
    ba: 'ba'
  }
}
```

and `tree_reject` the Hash:
```ruby
{
  a: {
    aa: :aaa
  }
}
```

your new hash will be:
```ruby
{
  a: {
    aa: {
      aab: 'aab'
    }
  }, 
  b: {
    ba: 'ba'
  }
} 
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tree_reject'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tree_reject

## Usage

`tree_reject` extends Ruby's built-in `Hash`:

```ruby
my_hash.tree_reject(ignored_keys)
```

It is also available for objects that support `to_h`.

```ruby
TreeReject.tree_reject(my_hash_like, ignored_keys)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then,
run `rake spec` to run the tests. You can also run `bin/console` for an
interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. 

To release a new version, update the version number in `version.rb`, and then
run `bundle exec rake release`, which will create a git tag for the version,
push git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org)
.

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/salsify/tree_reject.## License

The gem is available as open source under the terms of the
[MIT License](http://opensource.org/licenses/MIT).
