require 'spec_helper'

RSpec.describe LetterService::Address do
  describe '.import' do
    let(:name) { 'Eric Nelson' }
    let(:address_model) { build :address }
    it 'matches the parameters of the AR Address' do
      new_address = LetterService::Address.import name, address_model
      expect(new_address.name).to eq name

      expect(new_address.street1).to eq address_model.street1
      expect(new_address.street2).to eq address_model.street2
      expect(new_address.city).to eq address_model.city
      expect(new_address.state).to eq address_model.state
      expect(new_address.zipcode).to eq address_model.zipcode
    end
  end
end
