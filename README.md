# MkSunmoon

## Introduction

This is the gem library which calculates rise/set/meridian_passage of Sun and Moon.(Timezone: JST)

### Computable items

Sunrise(time, azimath), Sunset(time, azimath), Sun's meridian passage(time, altitude),
Moorise(time, azimath), Moonset(time, azimath), Moon's meridian passage(time, altitude),

### Original Text

「日の出・日の入りの計算―天体の出没時刻の求め方」（長沢 工 著）

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mk_sunmoon'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mk_sunmoon

## Usage

``` ruby
require 'mk_sunmoon'

o = MkSunmoon.new("20160613", 35.47222222, 133.05055556, 0)
exit unless o

p o.sunrise   # => ["04:51:52", 60.3625538738466]
p o.sunset    # => ["19:23:59", 299.679632987787]
p o.sun_mp    # => ["12:07:52", 77.75865299128155]
p o.moonrise  # => ["12:48:14", 89.56165470119508]
p o.moonset   # => ["00:32:24", 272.8282647107956]
p o.moon_mp   # => ["18:58:52", 54.1049869601976]
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment. Run `bundle exec mk_sunmoon` to use the gem in this directory, ignoring other installed copies of this gem.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/komasaru/mk_sunmoon.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

