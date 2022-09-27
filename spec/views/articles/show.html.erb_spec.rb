require 'rails_helper'

RSpec.describe "articles/show", type: :view do
  let(:related_articles) { create_list(:article, 3, status: 'published') }
  let(:showed_article) { create(:article, status: 'published') }

  before(:each) do
    assign(:article, showed_article)
    assign(:articles, related_articles)
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/[article]{4}/)
  end
end
