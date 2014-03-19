class AddGuidToShows < ActiveRecord::Migration
  def change
    add_column :shows, :guid, :integer, :null => false, :default => 0
  end
end
