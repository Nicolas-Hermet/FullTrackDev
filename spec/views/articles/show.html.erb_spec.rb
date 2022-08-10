require 'rails_helper'

RSpec.describe "articles/show", type: :view do
  before(:each) do
    @article = assign(:article, Article.create!(
                                  title: "Title",
                                  content: nil,
                                  category: 2,
                                  status: 1
                                ))
  end

  it "renders attributes in <p>" do
    pending 'still, another failing test'
    render
    expect(rendered).to match(/Title/)
    expect(rendered).to match(//)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
  end
end
