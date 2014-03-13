class CreateShows < ActiveRecord::Migration
  def change
    create_table :shows do |t|
      t.string :title
      t.text :description
      t.string :link
      t.string :tags
      t.integer :views
      t.integer :podcast_id

      t.timestamps
    end
  end
end
