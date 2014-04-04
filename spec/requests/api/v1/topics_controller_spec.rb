require 'spec_helper'

describe API::V1::TopicsController do
  
  describe 'GET /topics' do
    let!(:topics) { [FactoryGirl.create(:topic), FactoryGirl.create(:topic)] }
    
    it 'renders JSON with all topics' do
      get '/api/v1/topics'
      response.should be_success
      response.body.should == topics.reverse.to_json
    end
  end

end