class User < ActiveRecord::Base
  attr_accessor :uas
  delegate :login, to: :uas

  belongs_to :concierge, class_name: 'User'
  has_many :users, foreign_key: :concierge_id

  has_many :topics
  has_many :messages

  scope :common, -> { where(concierge: false) }
  scope :concierges, -> { where(concierge: true) }

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

  def sns
    @sns ||= Person.find(siebel_id)
  end

  def sns_company
    @sns_company ||= Ds::Sns.as siebel_id, 'siebel' do
      sns.companies.first
    end
  end

  def siebel_company
    @siebel_company ||= Account.find(sns_company.id) if sns_company
  end

  private

    def set_siebel_id
      self.siebel_id = siebel.id
    end
end
