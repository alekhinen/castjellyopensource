class PageController < ApplicationController
  def index
    # Get all podcast_id's that are associated with the current_user
    @subscriptions = Subscription.where(:user_id => current_user.id).select(:podcast_id).to_sql
    # Get all podcasts that have the same id's as the subscriptions and order by by which one was updated last
    @podcasts = Podcast.where("id IN (#{@subscriptions})").order("updated_at DESC")
  end

  # POST 
  def load_more_shows
    @shows = Show.where(:podcast_id => params[:id], :created_at => (900.years.ago..48.hours.ago)).order("created_at ASC").limit(10)
    puts @shows
    respond_to do |format|               
      format.js
    end 
  end
end
