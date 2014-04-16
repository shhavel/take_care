# TakeCare

[![Gem Version](https://badge.fury.io/rb/take_care.png)](http://badge.fury.io/rb/take_care)
[![Build Status](https://travis-ci.org/shhavel/take_care.png?branch=master)](https://travis-ci.org/shhavel/take_care)
[![Dependency Status](https://gemnasium.com/shhavel/take_care.png)](https://gemnasium.com/shhavel/take_care)
[![Code Climate](https://codeclimate.com/github/shhavel/take_care.png)](https://codeclimate.com/github/shhavel/take_care)
[![Coverage Status](https://coveralls.io/repos/shhavel/take_care/badge.png)](https://coveralls.io/r/shhavel/take_care)

Sidekiq wrapper for activerecord model (or any class which instances are fetched by #id)

Method #take_care(method, *args) that delegates actual performing of own method to sidekiq

## Installation

Add this line to your application's Gemfile:

    gem 'take_care'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install take_care

## Usage

Include TakeCare::Reliable into your model and you will get #take_care method inside of it.

```rb
class Human < ActiveRecord::Base
  include TakeCare::Reliable

  def hard_work(box1, box2)
    # Code that needs to be executed in background
  end
end

human = Human.create(name: 'Alex')

human.take_care :hard_work, 'heavy box', 'second heavy box' # This goes to sidekiq

human.take_care_of :hard_work, 'heavy box', 'second heavy box' # Same using alias

# Same using dynamic methods (method is defined after first call)
human.take_care_hard_work 'heavy box', 'second heavy box'
# Or
human.take_care_of_hard_work 'heavy box', 'second heavy box'

```

There is also support for class methods for all kind of classes (not only ActiveRecord::Base).

```rb
class Human
  include TakeCare::Reliable

  def self.do_stuff(s1, s2)
    # Code that needs to be executed in background
  end
end

Human.take_care :do_stuff, 'arg1', 'arg2' # This goes to sidekiq

Human.take_care_of :do_stuff, 'arg1', 'arg2' # Same using alias

# Same using dynamic methods (method is defined after first call)
Human.take_care_do_stuff 'arg1', 'arg2'
# Or
Human.take_care_of_do_stuff 'arg1', 'arg2'

```

## Contributing

1. Fork it ( https://github.com/shhavel/take_care/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
