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

  describe '#recover_password' do
    let(:login) { '+71111111130' }
    let(:user_id) { 'UAS100755' }
    let(:user) do
      user = Uas::User.new
      user.user_id = user_id
      user.user_sys_name = 'siebel'
      user
    end
    let(:old_password) { 'qwerty123' }
    let(:new_password) { 'testtesttest' }
    after { user.change_password(new_password, old_password) }

    it 'changes password of the user' do
      # Old password works, a new one does not
      expect { Uas::User.login(login, new_password) }.to raise_exception Uas::InvalidCredentials
      Uas::User.login(login, old_password).should be_kind_of Uas::LoginInfo

      # Recover the password
      user.recover_password(new_password).should == true

      # New password works, the old one does not
      expect { Uas::User.login(login, old_password) }.to raise_exception Uas::InvalidCredentials
      Uas::User.login(login, new_password).should be_kind_of Uas::LoginInfo
    end
  end
end
