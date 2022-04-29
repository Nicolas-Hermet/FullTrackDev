require 'rails_helper'

RSpec.describe "articles/index", type: :view do
  before(:each) do
    assign(:articles, [
      Article.create!(
        title: "Title",
        content: nil,
        category: 2,
        status: 3
      ),
      Article.create!(
        title: "Title",
        content: nil,
        category: 2,
        status: 3
      )
    ])
  end

  it "renders a list of articles" do
    render
    assert_select "tr>td", text: "Title".to_s, count: 2
    assert_select "tr>td", text: nil.to_s, count: 2
    assert_select "tr>td", text: 2.to_s, count: 2
    assert_select "tr>td", text: 3.to_s, count: 2
  end
end
