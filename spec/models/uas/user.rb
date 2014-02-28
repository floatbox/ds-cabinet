require 'spec_helper'

describe Uas::User do
  describe '.exist?' do
    it 'returns true for existed users' do
      Uas::User.exist?('+71111111114').should be_true
    end

    it 'returns true for new users' do
      Uas::User.exist?(SecureRandom.hex(32)).should be_false
    end
  end
end
