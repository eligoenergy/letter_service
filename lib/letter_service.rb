require "letter_service/version"

require 'letter_service/address'

require 'postalmethods'
require 'lob'

# This library provides a provider agnostic way of sending letters, and configuring different providers / drivers
# The service needs to be configured with all of the drivers you might use, and set any defaults you will use
# Here is an example configuration
=begin
LetterService.configure do |config|
  config.drivers = {
    lob_test: LetterService::LobDriver.new(api_key: "test_171de008aa952499c4a4dc171addf8de049"),

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

  # I decided to put configuration stuff in its own class, so there is only the one 
  # module/class variable
  class Configuration
    # This is a symbol, so there are no references to the driver outside of @drivers
    attr_accessor :default_driver

    # This should be a hash of configured drivers. Use the keys there to .use the driver
    # Or set it as the default
    attr_accessor :drivers

    # This should be a LetterService::Address, which will be used as the from address
    # for applicable drivers
    attr_accessor :from_address

    def configure
      yield self
    end

    # Validation on the address reader
    def from_address
      raise "Please set LetterService.config.from_address" unless @from_address
      @from_address
    end
  end

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
    default_driver.send_letter *args
  end

  # This is an abstract driver class, and should not be used directly
  class LetterDriver
    attr_reader :client
    
    # Override this method in your driver to be called
    # just before you send a letter or something
    def use
      self
    end

    # `send_letter` must have a common interface for sending letters,
    #  so you can change drivers as you need
    def send_letter(content, to_address, options={})
      raise NotImplementedError, "Drivers must implement their own sending method"
    end 

    # Convert a LetterService::Address to a driver specific address hash
    def addr_hash address
      raise NotImplementedError, "Drivers must specify their own way of formatting addresses"
    end
  end

  # Driver for Lob, needs an api_key
  # See https://github.com/lob/lob-ruby
  class LobDriver < LetterDriver
    def initialize options
      @client = Lob.load options
    end

    # Only set options here that Lob allows, or those that are deleted here
    def send_letter(content, to_address, options={})

      options.delete(:fake)
      options.delete(:letter)

      begin
        letter = client.letters.create({
            to: addr_hash(to_address),
            from: addr_hash(LetterService.config.from_address),
            file: content,
            color: false,
            template: false
          }.merge(options)
        )
        return letter
      rescue
        print $!, $!.backtrace
        raise $!
      end
    end

    def addr_hash address
      {
        name: address.name,
        address_line1: address.street1,
        address_line2: address.street2,
        address_city: address.city,
        address_state: address.state,
        address_zip: address.zipcode,
        address_country: "US"
       }
    end
  end

  # Postal methods driver, it needs an api_key
  # See https://github.com/eligoenergy/postalmethods
  # Or https://github.com/imajes/postalmethods
  class PostalMethodsDriver < LetterDriver
    def initialize options
      @client = PostalMethods::Client.new(options)
    end

    # The client needs to be prepared before use,
    # but this generates a lot of output, so it waits to do it until it needs to
    def use
      @client.prepare! unless @client.prepared
      self
    end

    # Using the error handling that was in letter.rb
    def send_letter(content, to_address, options={})
      letter_log = options[:letter]
      begin
        retval = options[:fake] ? 1 : client.send_letter_with_address(content, options[:description], addr_hash(to_address))
      rescue PostalMethods::APIException => e
        raise e
        Zendesk.new.create_failed_to_send_letter(e.message + "\n" + letter_log.inspect + "\nhttp://www.postalmethods.com/statuscodes#webservice", account)
        retval = e.status
        letter_log.change_status(:failed)
      end

      if retval > 0 then
        letter_log.postal_methods_id = retval
        letter_log.change_status(:sent) # This will also save
      end
    end

    def addr_hash address
      {
        :AttentionLine1 => address.name,
        :Address1 => address.street1,
        :Address2 => address.street2,
        :City => address.city,
        :State => address.state,
        :PostalCode => address.zipcode,
        :Country => "USA"
      }
    end
  end
end

