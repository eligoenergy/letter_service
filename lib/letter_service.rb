require 'letter_service/version'

require 'letter_service/configuration'
require 'letter_service/address'
require 'letter_service/letter_driver'
require 'letter_service/drivers/lob'
require 'letter_service/drivers/postalmethods'

# This library provides a provider agnostic way of sending letters, and configuring different providers / drivers
# The service needs to be configured with all of the drivers you might use, and set any defaults you will use
# Here is an example configuration
=begin
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
=end
module LetterService
  def self.config
    @config ||= Configuration.new
  end

  def self.configure(&block)
    config.configure(&block)
  end

  # use returns a specific driver, as well as performs the "use" callback on the driver
  def self.use(driver_key)
    config.drivers[driver_key].use
  end

  # Get the default driver
  def self.default_driver
    use(config.default_driver)
  end

  # Alias for sending a letter using the default driver
  def self.send_letter(*args)
    default_driver.send_letter(*args)
  end
end
