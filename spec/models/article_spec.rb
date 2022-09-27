require 'rails_helper'
require 'active_support/testing/time_helpers'

RSpec.describe Article, type: :model do
  let(:article_attributes) { attributes_for(:article) }

  %i[title category status].each do |argument|
    it "validates presence of #{argument}" do
      article_attributes[argument] = nil
      expect(Article.new(article_attributes)).not_to be_valid
    end
  end

  describe 'update' do
    let(:article) { create(:article, status: 'draft', published_at: nil) }
    let(:update_params) do
      { title: Faker::Book.title, status: 'draft' }
    end

    context 'when arguments contain status: "draft"' do
      it 'does not update the "published_at" attribute' do
        article.update(update_params)
        expect(article.reload.published_at).to be_nil
      end
    end

    context 'when arguments contain status: "published"' do
      context 'when article already had a published status or a published_at dateTime' do
        let(:date) { '1986-02-15' }
        let(:possible_attributes) do
          [{ status: 'published' }, { published_at: date }]
        end
        let(:random_attribute) { possible_attributes.sample }
        let(:article) { create(:article, random_attribute) }
        let(:article_published_date) { article.published_at }

        it 'does not update "published_at" attribute' do
          article.update(update_params)
          expect(article.reload.published_at).to eq(article_published_date)
        end
      end

      context 'when article had status: "draft" and "published_at: nil"' do
        it 'does update the published_at attribute with Time.now' do
          update_params[:status] = 'published'
          freeze_time
          article.update(update_params)
          expect(article.reload.published_at).to eq(Time.now)
          unfreeze_time
        end
      end
    end
  end
end
