class User < ActiveRecord::Base
  attr_accessor :uas
  delegate :login, to: :uas

  has_many :topics

  before_validation :set_siebel_id, unless: :siebel_id

  def self.find_by_token(token)
    uas = Uas::User.find_by_token(token)
    user = User.find_or_create_by_integration_id(uas.user_id)
    user.uas = uas
    user
  rescue Uas::Error
    nil
  end

  # @return [Contact] Siebel representation of user
  def siebel
    @siebel ||= if siebel_id
      Contact.find(siebel_id)
    else
      Contact.find_by_integration_id(integration_id)
    end
  end

  def concierge?
    false
  end

  private

    def set_siebel_id
      self.siebel_id = siebel.id
    end
end
