class AddSlugToArticles < ActiveRecord::Migration[6.1]
  def change
    add_column :articles, :slug, :string
  end
end
