# StringSatisfy

create a string pattern with &(represents AND) and |(represents OR), check whether it can be satisfied with given strings.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'string_satisfy'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install string_satisfy

## Usage

```ruby
object = StringSatisfy.new '( (A | B) & (C | D) ) | ( (E | F) & (G | H) )'

object.satisfied_with? 'A', 'B'
=> false

object.satisfied_with? 'A', 'C'
=> true

object.satisfied_with? 'E', 'F'
=> false

object.satisfied_with? 'E', 'G'
=> true

object.satisfied_with? 'A', 'E'
=> false

object.satisfied_with? 'A', 'F', 'G'
=> true
```

## Contributing

1. Fork it ( https://github.com/waterflowseast/string_satisfy/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
