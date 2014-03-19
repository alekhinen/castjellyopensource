class Show < ActiveRecord::Base
    #########################
    # Relationships #########
    belongs_to :podcast


    #########################
    # Validations ###########
    validates_presence_of :title, :description, :link
end
