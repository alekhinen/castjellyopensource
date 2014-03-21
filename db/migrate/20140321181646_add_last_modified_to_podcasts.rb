class AddLastModifiedToPodcasts < ActiveRecord::Migration
  def change
    add_column :podcasts, :last_modified, :datetime
  end
end
