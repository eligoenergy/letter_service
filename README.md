# LetterService

This library provides a provider agnostic way of sending letters, and configuring different providers / drivers.
The service needs to be configured with all of the drivers you might use, and set any defaults you will use


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'letter_service'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install letter_service

## Usage

### Here is an example configuration
```ruby
LetterService.configure do |config|
  config.drivers = {
    lob_test: LetterService::LobDriver.new(api_key: ENV["LOB_TEST_API_KEY"]),

    lob: LetterService::LobDriver.new(api_key: ENV["LOB_API_KEY"]),

    postal: LetterService::PostalMethodsDriver.new(api_key: CONFIG.postal_methods.api_key)

  }

  config.default_driver = :lob

  config.from_address = LetterService::Address.new(
    name: 'Eligo Energy, LLC',
    street1: '201 W Lake St',
    street2: 'Suite 151',
    city: 'Chicago',
    state: 'IL',
    zipcode: 'US',
    zipcode: '60606'
  )
end
```

To send a letter, you would then call `LetterService.send_letter(document, to_address, **options)`

To use a different driver, you would use the same send_letter parameters, but would call `LetterService.use(:driver_key)` to select a specific driver or service to send with

Any address must be a valid `LetterService::Address`

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake false` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/eligoenergy/letter_service.

