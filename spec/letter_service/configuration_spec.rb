require "spec_helper"

RSpec.describe LetterService::Configuration do
  let(:config) { LetterService::Configuration.new }
  
  describe "#configure" do
    it "configures itself with a block" do
      config.configure do |block_config|
        expect(block_config).to eql config
      end
    end
  end
  describe "#from_address" do
    context "it is not set" do
      it "raises an error" do
        expect do
          config.from_address
        end.to raise_exception "Please set LetterService.config.from_address"
      end
    end

    context "it is set" do
      let(:some_address) { LetterService::Address.import("foo", build(:address)) }
      before do
        config.from_address = some_address
      end
      it "returns the address" do
        expect(config.from_address).to eql some_address
      end
    end
  end
end