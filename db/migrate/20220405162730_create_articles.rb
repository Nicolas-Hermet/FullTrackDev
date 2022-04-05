class CreateArticles < ActiveRecord::Migration[6.1]
  def change
    create_table :articles, id: :uuid do |t|
      t.string :title
      t.integer :category, default: 0
      t.integer :status, default: 0
      t.datetime :modified_at, default: DateTime.now
      t.datetime :published_at, default: DateTime.now

      t.timestamps
    end
  end
end
