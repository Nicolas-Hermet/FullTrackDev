require 'rails_helper'

RSpec.describe "articles/index", type: :view do
  let(:articles) { create_list(:article, 2, status: 'published') }

  before(:each) do
    assign(:articles, Kaminari.paginate_array(articles).page(1))
    assign(:last_published, articles.first)
  end

  context 'when admin' do

    it "renders a list of articles" do
      render

      assert_select "h3", count: 3
      assert_select "article", count: 3
    end
  end
end
