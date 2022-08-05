require 'rails_helper'

RSpec.describe "articles/index", type: :view do
  before(:each) do
    assign(:articles, [
             Article.create!(
               title: "Title",
               content: nil,
               category: 2,
               status: 0
             ),
             Article.create!(
               title: "Title",
               content: nil,
               category: 2,
               status: 1
             )
           ])
  end

  it "renders a list of articles" do
    pending 'This test has to be fixed'
    render
    assert_select "tr>td", text: "Title".to_s, count: 2
    assert_select "tr>td", text: nil.to_s, count: 2
    assert_select "tr>td", text: 2.to_s, count: 2
    assert_select "tr>td", text: 3.to_s, count: 2
  end
end
