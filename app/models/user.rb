class User < ActiveRecord::Base
  attr_accessor :uas
  delegate :login, to: :uas
  delegate :first_name, :first_name=,
           :last_name, :last_name=,
           :middle_name, :middle_name=,
           :email, :email=,
           :phone,
           to: :siebel

  belongs_to :concierge, class_name: 'User'
  has_many :users, foreign_key: :concierge_id

  # @return [ActiveRecord::Relation<Topic>] topics that are related to this user
  has_many :topics

  # @return [ActiveRecord::Relation<Topic>] topics that were created by this user
  has_many :authored_topics, class_name: 'Topic', foreign_key: :author_id

  has_many :messages
  has_many :notifications
  has_many :search_queries
  has_many :access_purchases
  has_one  :registration

  scope :common, -> { where(is_concierge: false) }
  scope :concierges, -> { where(is_concierge: true) }

  after_create :reset_api_token, unless: :api_token
  before_validation :set_siebel_id, unless: :siebel_id

  # Finds a user by UAS token
  # @note This method has nothing common with API tokens.
  # @param token [String] UAS token
  # @return [User] user with passed UAS token if exists
  # @return [nil] there is no user with such a token
  def self.find_by_token(token)
    uas = Uas::User.find_by_token(token)
    user = User.find_or_create_by(integration_id: uas.user_id)
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
  rescue
    nil
  end

  def siebel_company
    @siebel_company ||= Account.find(sns_company.id) if sns_company
  end

  # Sets new API token
  def reset_api_token
    update_column(:api_token, generate_api_token)
  end

  def update_last_activity
    time = Time.now
    self.last_activity_at = time
    update_column(:last_activity_at, time)
  end

  # @return [Boolean] whether this user is online
  # @note It depends on last activity time
  def online?
    return false unless last_activity_at
    Time.now <= 5.minutes.since(last_activity_at)
  end

  def has_paid_access?
    !!( access_purchases && (ap = access_purchases.last) && ap.paid_and_not_expired? )
  end

  private

    # @return [String] unique API token
    def generate_api_token
      loop do
        token = SecureRandom.hex(32)
        break token unless self.class.exists?(api_token: token)
      end
    end

    def set_siebel_id
      self.siebel_id = siebel.id
    end

end
