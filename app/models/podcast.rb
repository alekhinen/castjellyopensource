class Podcast < ActiveRecord::Base
    #########################
    # Relationships #########
    has_many :shows, dependent: :destroy


    #########################
    # Validations ###########
    validates_presence_of :title, :description, :link, :rss_link, :tags
    validates_uniqueness_of :title, :rss_link, :link

    # Avatar ##################
    has_attached_file :image,
                      :url  => "/assets/podcasts/:id/:style/:basename.:extension",
                      :path => ":rails_root/public/assets/podcasts/:id/:style/:basename.:extension",
                      :default_url => "/assets/default_podcast.png"
    validates_attachment_size :image, :less_than => 5.megabytes
    validates_attachment_content_type :image, :content_type => ['image/jpeg', 'image/png']
    
end
