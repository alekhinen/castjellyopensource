class AddImageUrlToShows < ActiveRecord::Migration
  def change
    add_column :shows, :image_url, :string, :default => ""
  end
end
