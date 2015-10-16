require 'spec_helper'

RSpec.describe LetterService::LetterDriver do
  let(:driver) { LetterService::LetterDriver.new }
  it "implements the method interface" do
    expect{driver.send_letter(nil, nil)}.to raise_exception NotImplementedError
    expect{driver.addr_hash(nil)}.to raise_exception NotImplementedError
  end
  it "can be used" do
    expect(driver.use).to eql driver
  end
end
