require 'spec_helper'

describe UsersController do
  let(:login) { '+71111111114' }
  let(:password) { 'qwerty123' }

  describe 'POST token' do
    let(:request) { { token: token } }
    let(:session) { {} }

    context 'with valid request' do
      let(:login_info) { Uas::User.login(login, password) }
      let(:token) { login_info.token }
      let(:user) { login_info.user }

      it 'returns JSON with full user info' do
        post :token, request, session
        response.code.should == '200'
        json = JSON.parse(response.body)
        json['id'].should == '1-1LOG0C'
        json['name'].should == "#{user.first_name} #{user.last_name}"
        json['phone'].should == user.login
        json['ogrn'].should == '1127746082903'
      end
    end

    context 'with invalid request' do
      let(:token) { 'fake_token' }
      it 'responds with status code 500' do
        post :token, request, session
        response.code.should == '500'
      end
    end
  end

  describe 'POST token_light' do
    let(:request) { { token: token } }
    let(:session) { {} }

    context 'with valid request' do
      let(:login_info) { Uas::User.login(login, password) }
      let(:token) { login_info.token }
      let(:user) { login_info.user }

      it 'returns JSON with basic user info' do
        post :token_light, request, session
        response.code.should == '200'
        response.body.should == { name: "#{user.first_name} #{user.last_name}",
                                  phone: user.login }.to_json
      end
    end

    context 'with invalid request' do
      let(:token) { 'fake_token' }
      it 'responds with status code 500' do
        post :token_light, request, session
        response.code.should == '500'
      end
    end
  end
end