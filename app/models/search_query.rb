class SearchQuery < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :user, :text
end
