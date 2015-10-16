require 'lob'
module LetterService
  # Driver for Lob, needs an api_key
  # See https://github.com/lob/lob-ruby
  class LobDriver < LetterDriver
    def initialize(options)
      @client = Lob.load options
    end

    # Only set options here that Lob allows, or those that are deleted here
    def send_letter(content, to_address, options = {})
      options.delete(:fake)
      options.delete(:letter)
      params = {
        to: addr_hash(to_address),
        from: addr_hash(LetterService.config.from_address),
        file: content,
        color: false,
        template: false
      }.merge(options)

      client.letters.create(params)
    end

    def addr_hash(address)
      {
        name: address.name,
        address_line1: address.street1,
        address_line2: address.street2,
        address_city: address.city,
        address_state: address.state,
        address_zip: address.zipcode,
        address_country: 'US'
      }
    end
  end
end
