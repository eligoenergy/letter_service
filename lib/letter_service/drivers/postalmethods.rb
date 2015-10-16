require 'postalmethods'

module LetterService
  # Postal methods driver, it needs an api_key
  # See https://github.com/eligoenergy/postalmethods
  # Or https://github.com/imajes/postalmethods
  class PostalMethodsDriver < LetterDriver
    def initialize(options)
      @client = PostalMethods::Client.new(options)
    end

    # The client needs to be prepared before use,
    # but this generates a lot of output, so it waits to do it until it needs to
    def use
      @client.prepare! unless @client.prepared
      self
    end

    # Using the error handling that was in letter.rb
    def send_letter(content, to_address, options = {})
      letter_log = options[:letter]
      begin
        retval = options[:fake] ? 1 : client.send_letter_with_address(content, options[:description], addr_hash(to_address))
      rescue PostalMethods::APIException => e
        Zendesk.new.create_failed_to_send_letter(e.message + "\n" + letter_log.inspect + "\nhttp://www.postalmethods.com/statuscodes#webservice", account)
        retval = e.status
        letter_log.change_status(:failed)
        raise e
      end

      if retval > 0
        letter_log.postal_methods_id = retval
        letter_log.change_status(:sent) # This will also save
      end
    end

    def addr_hash(address)
      {
        AttentionLine1: address.name,
        Address1: address.street1,
        Address2: address.street2,
        City: address.city,
        State: address.state,
        PostalCode: address.zipcode,
        Country: 'USA'
      }
    end
  end
end
