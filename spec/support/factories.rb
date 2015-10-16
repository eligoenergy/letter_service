require 'factory_girl'

FactoryGirl.define do
  factory :address, class: 'LetterService::Address' do
    street1 '205 W Randolph St'
    street2 'Ste 1040'
    city 'Chicago'
    state 'IL'
    zipcode '60606'
  end
end
