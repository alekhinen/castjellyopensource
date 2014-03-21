class ChangeDataTypeForGuidToShows < ActiveRecord::Migration
  def self.up
    change_column :shows, :guid,  :bigint
  end
  
  def self.down
    change_column :shows, :guid,  :int
  end
end
