require 'spec_helper'
require 'password_sms_notifier'

describe PasswordSmsNotifier do

  let(:phone) { "+79261111111" } # sorry for that, stranger
  let(:password) { "qwerty123" } 

  it "#text" do
    text = PasswordSmsNotifier.new(phone, password).text
    text.should include(phone)
    text.should include(password)
  end

  context "valid phone" do
    it "#send" do
      allow(Dsreda::Sms).to receive(:send).and_return("606127")
      result = PasswordSmsNotifier.new(phone, password).send
      result.should match /\A\d{1,}\Z/ # e.g. "606127" or "121940"
    end
  end

  context "invalid phone" do
    let(:phone) {"+7495"}
    it "#send" do
      allow(Dsreda::Sms).to receive(:send).and_return(false)
      result = PasswordSmsNotifier.new(phone, password).send
      result.should be false
    end
  end
end
