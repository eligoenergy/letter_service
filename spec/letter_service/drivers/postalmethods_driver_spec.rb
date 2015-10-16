require 'spec_helper'

RSpec.describe LetterService::PostalMethodsDriver do
  let(:driver) do
    LetterService::PostalMethodsDriver.new(api_key: '8b2a6d85-e22d-464d-9ea8-ed77c180baec')
  end

  let(:some_address) do
    LetterService::Address.import("Eric Nelson", build(:address))
  end

  let(:example_pdf) do
    open("spec/fixtures/letter_example.pdf")
  end


  let(:letter_log) { double("Letter") }

  it "must be used to prepare the connection" do
    VCR.use_cassette("postal_prepare") do
      driver.use
    end
  end

  it "successfully sends a letter" do
    expect(letter_log).to receive(:change_status).with(:sent)
    expect(letter_log).to receive(:postal_methods_id=)

    VCR.use_cassette("postal_send_letter") do
      driver.use.send_letter(example_pdf, some_address,
                             description: "RSpec Test",
                             letter: letter_log)
    end
  end
end
