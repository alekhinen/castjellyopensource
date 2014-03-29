# This model represents the many-to-many relationship between users and podcasts
class Subscription < ActiveRecord::Base
    belongs_to :user
    belongs_to :podcast
end
