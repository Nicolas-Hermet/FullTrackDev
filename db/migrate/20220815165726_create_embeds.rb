class CreateEmbeds < ActiveRecord::Migration[6.1]
  def change
    create_table :embeds, id: :uuid do |t|
      t.string :url
      t.text :response
      t.string :type
      t.text :html
      t.string :title
      t.string :thumbnail_url
      t.integer :width
      t.integer :height
      t.integer :thumbnail_width
      t.integer :thumbnail_height
      t.string :embed_type
      t.string :author_url
      t.string :author_name
      t.string :provider_name
      t.string :provider_url
      t.string :version

      t.timestamps
    end
    add_index :embeds, [:id, :type], name: "index_embeds_on_id_and_type"
  end
end
