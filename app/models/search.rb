class Search
  attr_accessor :user, :query

  def initialize(user, query)
    @user = user
    @query = query
  end

  def any?
    !banned? && (topics.any? || messages.any?)
  end

  def banned?
    banned_words.include?(downcase_query)
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

    def banned_words
      banned_words = ConfigItem['search_banned_words']
      banned_words = banned_words.split("\r\n").map { |s| s.split(' ') }.flatten
      banned_words.map { |word| word.mb_chars.downcase.to_s }
    end
end