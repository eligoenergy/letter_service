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
      fail InvalidConfigException, 'Please set LetterService.config.from_address' unless @from_address
      @from_address
    end
  end

  # Something is wrong with your configuration
  class InvalidConfigException < Exception
  end
end
