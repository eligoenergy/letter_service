module LetterService
  # This is a standard way to represent addresses for this library
  # I made it not use the AR one by default since I might pull this into its own gem
  # It also has an extra name parameter
  class Address
    attr_accessor :name, :street1, :street2, :city, :state, :zipcode

    def initialize(hash={})
      hash.each do |key, value|
        send("#{key}=", value)
      end
    end

    # Import an AR Address into a letter address. Needs a recipient name
    def self.import name, address
      new(
        name:    name,
        street1: address.street1,
        street2: address.street2,
        city:    address.city,
        state:   address.state,
        zipcode: address.zipcode,
      )
    end
  end
end
