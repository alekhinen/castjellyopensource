class ChangeDataTypeForDescriptionToPodcasts < ActiveRecord::Migration
  def self.up
    change_column :podcasts, :description, :text, :limit => nil, :default => ""
  end
  
  def self.down
    change_column :podcasts, :description, :string
  end
end
