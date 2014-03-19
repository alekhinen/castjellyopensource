class AddRssLinkToPodcasts < ActiveRecord::Migration
  def change
    add_column :podcasts, :rss_link, :string, :null => false, :default => "" 
  end
end
