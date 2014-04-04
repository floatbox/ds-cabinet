require 'spec_helper'

describe 'Topics API' do
  let(:user_1) { User.find_or_create_by_integration_id(USERS[:user_1][:integration_id]) }
  let(:user_2) { User.find_or_create_by_integration_id(USERS[:user_2][:integration_id]) }

  describe 'GET /api/v1/topics' do
    let!(:topics) { [FactoryGirl.create(:topic), FactoryGirl.create(:topic)] }
    
    it 'renders JSON with all topics' do
      get '/api/v1/topics'
      response.should be_success
      response.body.should == topics.reverse.to_json
    end
  end

  describe 'POST /api/v1/users/:user_id/topics' do
    let(:headers) { { 'CONTENT_TYPE' => Mime::JSON.to_s } }

    it 'creates new post' do
      post "/api/v1/users/#{user_1.id}/topics", { topic: { widget_type: 'purchase', widget_options: '{}' } }.to_json, headers
      response.status.should == 201
      json[:user_id].should == user_1.id
      json[:author_id].should == user_1.id
      json[:widget_type].should == 'purchase'
      json[:widget_options].should == '{}'
      json[:text].should == 'purchase'
    end

    it 'creates new post with specified author' do
      post "/api/v1/users/#{user_1.id}/topics", { topic: { author_id: user_2.id, widget_type: 'purchase', widget_options: '{}' } }.to_json, headers
      response.status.should == 201
      json[:user_id].should == user_1.id
      json[:author_id].should == user_2.id
      json[:widget_type].should == 'purchase'
      json[:widget_options].should == '{}'
      json[:text].should == 'purchase'
    end

    it 'responds with errors for invalid data' do
      post "/api/v1/users/#{user_1.id}/topics", { topic: { widget_type: 'unknown_widget' } }.to_json, headers
      response.status.should == 422
    end
  end

end