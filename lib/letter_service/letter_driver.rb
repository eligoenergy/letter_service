module LetterService
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
    def send_letter(_content, _to_address, _options = {})
      fail NotImplementedError, 'Drivers must implement their own sending method'
    end

    # Convert a LetterService::Address to a driver specific address hash
    def addr_hash(_address)
      fail NotImplementedError, 'Drivers must specify their own way of formatting addresses'
    end
  end
end
