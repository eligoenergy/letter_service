require 'spec_helper'

RSpec.describe LetterService::LobDriver do
  let(:driver) do
    LetterService::LobDriver.new(api_key: 'test_171de008aa952499c4a4dc171addf8de049')
  end

  let(:some_address) do
    LetterService::Address.import('Eric Nelson', build(:address))
  end

  let(:example_pdf) do
    open('spec/fixtures/letter_example.pdf')
  end

  before(:each) do
    LetterService.configure do |config|
      config.from_address = LetterService::Address.new(
        name: 'Eligo Energy, LLC',
        street1: '201 W Lake St',
        street2: 'Suite 151',
        city: 'Chicago',
        state: 'IL',
        zipcode: '60606'
      )
    end
  end

  it 'requires a return address' do
    LetterService.config.from_address = nil
    expect do
      driver.use.send_letter(example_pdf, some_address, description: 'RSpec Test')
    end.to raise_error LetterService::InvalidConfigException
  end

  it 'creates a valid Lob Client' do
    VCR.use_cassette('lob_auth_test') do
      expect { driver.client.jobs.list }.to_not raise_error
    end
  end

  it 'successfully sends a letter' do
    VCR.use_cassette('lob_send_letter') do
      driver.use.send_letter(example_pdf, some_address, description: 'RSpec Test')
    end
  end
end
