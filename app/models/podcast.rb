class Podcast < ActiveRecord::Base
    #########################
    # Relationships #########
    has_many :shows, dependent: :destroy


    #########################
    # Validations ###########
    validates_presence_of :title, :description, :link, :rss_link, :tags
    validates_uniqueness_of :title, :rss_link, :link

    
end
