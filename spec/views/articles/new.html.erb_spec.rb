require 'rails_helper'

RSpec.describe "articles/new", type: :view do
  before(:each) do
    assign(:article, Article.new(
                       title: "MyString",
                       content: nil,
                       category: 1,
                       status: 1
                     ))
  end

  it 'renders a specific title and paragraph' do
    render

    assert_select 'p', 'Vas-y lâche toi !'
  end

  it "renders new article form" do
    render

    assert_select "form[action=?][method=?]", articles_path, "post" do
      assert_select "input[name=?]", "article[title]"

      assert_select "input[name=?]", "article[content]"

      assert_select "select[name=?]", "article[category]"

      assert_select "select[name=?]", "article[status]"
    end
  end
end
