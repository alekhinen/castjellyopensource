class AddAttachmentImageToPodcasts < ActiveRecord::Migration
  def self.up
    change_table :podcasts do |t|
      t.attachment :image
    end
  end

  def self.down
    drop_attached_file :podcasts, :image
  end
end
