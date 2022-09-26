require 'rails_helper'

RSpec.describe Article, type: :model do
  let(:article_attributes) { attributes_for(:article) }

  %i[title category status].each do |argument|
    it "validates presence of #{argument}" do
      article_attributes[argument] = nil
      expect(Article.new(article_attributes)).not_to be_valid
    end
  end

end
