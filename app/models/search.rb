class Search
  attr_accessor :user, :query

  def initialize(user, query)
    @user = user
    @query = query
  end

  def any?
    topics.any? || messages.any?
  end

  def topics
    @topics ||= user.topics.where('LOWER(topics.text) LIKE ?', "%#{downcase_query}%")
  end

  def messages
    @messages ||= Message.joins(:topic).where(topics: { user_id: user.id }).where('LOWER(messages.text) LIKE ?', "%#{downcase_query}%")
  end

  private

    def downcase_query
      query.mb_chars.downcase.to_s
    end
end