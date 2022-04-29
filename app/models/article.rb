class Article < ApplicationRecord
  has_rich_text :content

  enum category: {
    perso: 0,
    tech: 1,
    remote: 2,
    racing: 3,
    good_read: 4
  }

  enum status: {
    draft: 0,
    published: 1,
  }

  def update(*args)
    args[0][:published_at] = DateTime.now if draft? && published_at.nil? && args[0][:status] == 'published'
    super
  end
end
