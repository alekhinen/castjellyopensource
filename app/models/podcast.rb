class Podcast < ActiveRecord::Base
    #########################
    # Relationships #########
    has_many :shows, dependent: :destroy
    
    # Many-to-many relationship between podcasts and users
    has_many :subscriptions
    has_many :users, :through => :subscriptions


    #########################
    # Validations ###########
    validates_presence_of :title, :description, :link, :rss_link, :tags
    validates_uniqueness_of :title, :rss_link, :link

    # Avatar ##################
    has_attached_file :image,
                      :default_url => "/assets/default_podcast.png"

    # :url  => "/assets/podcasts/:id/:style/:basename.:extension",
    # :path => ":rails_root/public/assets/podcasts/:id/:style/:basename.:extension",

    validates_attachment_size :image, :less_than => 5.megabytes
    validates_attachment_content_type :image, :content_type => ['image/jpeg', 'image/png']
    
end
