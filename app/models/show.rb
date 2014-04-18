class Show < ActiveRecord::Base
    #########################
    # Relationships #########
    belongs_to :podcast

    # Many-to-many relationship between shows and users
    has_many :saves
    has_many :users, :through => :saves


    #########################
    # Validations ###########
    validates_presence_of :title, :description, :link
end
