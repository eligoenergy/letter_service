# This will guess the User class
FactoryGirl.define do
  factory :address do
    street1 "205 W Randolph St"
    street2 "Ste 1040"
    city "Chicago"
    state "IL"
    zipcode "60606"
  end
end
