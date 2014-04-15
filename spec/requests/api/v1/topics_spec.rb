require 'spec_helper'

describe 'Topics API' do
  let!(:user_1) { User.find_or_create_by(integration_id: USERS[:user_1][:integration_id]) }
  let!(:user_2) { User.find_or_create_by(integration_id: USERS[:user_2][:integration_id]) }
  before { user_2.update_column(:concierge, true) unless user_2.concierge }

  let(:unauthorized_headers) { { 'CONTENT_TYPE' => Mime::JSON.to_s } }
  let(:authorized_headers) { unauthorized_headers.merge({ 'Authorization' => token_header(user_2.api_token) }) }

  describe 'GET /api/v1/topics' do
    let!(:topics) { [FactoryGirl.create(:topic), FactoryGirl.create(:topic)] }
    
    it 'renders JSON with all topics' do
      get '/api/v1/topics', {}, authorized_headers
      response.status.should == 200
      response.body.should == topics.reverse.to_json
    end
  end

  describe 'POST /api/v1/users/:user_id/topics' do

    context 'unauthorized access' do
      context 'no authorization token at all' do
        it 'responds with 401 status' do
          post "/api/v1/users/#{user_1.id}/topics", { topic: { widget_type: 'purchase', widget_options: '{}' } }.to_json, unauthorized_headers
          response.status.should == 401
        end
      end

      context 'authorization token does not belong to concierge' do
        let(:unauthorized_headers) { { 'CONTENT_TYPE' => Mime::JSON.to_s, 'Authorization' => token_header(user_1.api_token) } }
        it 'responds with 401 status' do
          post "/api/v1/users/#{user_1.id}/topics", { topic: { widget_type: 'purchase', widget_options: '{}' } }.to_json, unauthorized_headers
          response.status.should == 401
        end
      end
    end

    context 'authorized access' do
      it 'creates new topic by authorized concierge' do
        post "/api/v1/users/#{user_1.id}/topics", { topic: { widget_type: 'purchase', widget_options: '{}' } }.to_json, authorized_headers
        response.status.should == 201
        json[:user_id].should == user_1.id
        json[:author_id].should == user_2.id
        json[:widget_type].should == 'purchase'
        json[:widget_options].should == '{}'
        json[:text].should == 'purchase'
      end

      it 'responds with errors for invalid data' do
        post "/api/v1/users/#{user_1.id}/topics", { topic: { widget_type: 'unknown_widget' } }.to_json, authorized_headers
        response.status.should == 422
      end
    end
  end

end