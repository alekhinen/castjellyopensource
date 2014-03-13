class CreatePodcasts < ActiveRecord::Migration
  def change
    create_table :podcasts do |t|
      t.string :title
      t.string :description
      t.string :link
      t.string :tags
      t.integer :views

      t.timestamps
    end
  end
end
