class ShowsController < ApplicationController
  before_action :set_show, only: [:show, :edit, :update, :destroy]


  ###########################
  # Feedjira ################
  ###########################

  # Update / add new entries to show model
  def self.update_from_feed(feed_url, podcast_id)
    feed = Feedjira::Feed.fetch_and_parse(feed_url)
    add_entries(feed.entries, podcast_id)
  end

  # Update / add new entries to show model from feed continuously (every 24 hours)
  def self.update_from_feed_continuously(feed_url, podcast_id, delay_interval = 24.hours)
    feed = Feedjira::Feed.fetch_and_parse(feed_url)
    add_entries(feed.entries, podcast_id)
    loop do
      sleep delay_interval
      feed = Feedjira::Feed.update(feed)
      add_entries(feed.new_entries, podcast_id) if feed.updated?
    end
  end

  # Add new entries to the show model
  def self.add_entries(entries, podcast_id)
    entries.each do |entry|
      # remove special characters from guid of entry
      @entry_id = entry.id.gsub(/[^0-9A-Za-z]/, '')
      # if the show does not exist, create a new Show entry
      unless Show.exists?(:guid       => @entry_id, 
                          :title      => entry.title, 
                          :link       => entry.url, 
                          :podcast_id => podcast_id)
        Show.create(:title        => entry.title, 
                    :description  => entry.summary, 
                    :link         => entry.url, 
                    :published_at => entry.published, 
                    :guid         => @entry_id,
                    :image_url    => entry.itunes_image,  
                    :podcast_id   => podcast_id)
      end
    end
  end



  # GET /shows
  # GET /shows.json
  def index
    @shows = Show.all
  end

  # GET /shows/1
  # GET /shows/1.json
  def show
  end

  # # GET /shows/new
  # def new
  #   @show = Show.new
  # end

  # GET /shows/1/edit
  def edit
  end

  # # POST /shows
  # # POST /shows.json
  # def create
  #   @show = Show.new(show_params)

  #   respond_to do |format|
  #     if @show.save
  #       format.html { redirect_to @show, notice: 'Show was successfully created.' }
  #       format.json { render action: 'show', status: :created, location: @show }
  #     else
  #       format.html { render action: 'new' }
  #       format.json { render json: @show.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # PATCH/PUT /shows/1
  # PATCH/PUT /shows/1.json
  def update
    respond_to do |format|
      if @show.update(show_params)
        format.html { redirect_to @show, notice: 'Show was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @show.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /shows/1
  # DELETE /shows/1.json
  def destroy
    @show.destroy
    respond_to do |format|
      format.html { redirect_to shows_url }
      format.json { head :no_content }
    end
  end


  #############################################################################
  ## Additional Methods #######################################################
  #############################################################################

  # Create save relationship between current user and show
  # POST /shows/:id
  # NOTE: I would like to move these methods over to saves_controller
  def save
    @show = Show.where(:id => params[:id]).first
    unless Save.where(:user_id => current_user.id, :show_id => params[:id]).size > 0
      @save = Save.new(:user_id => current_user.id, :show_id => params[:id])
      if @save.save
        puts "Save successfully created!"
        redirect_to @show, :notice => "successfully saved!"
        # render :layout => false
      else
        puts "Save failed to be created!"
        render :layout => false
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_show
      @show = Show.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def show_params
      params.require(:show).permit(:title, :description, :link, :tags, :views, :podcast_id)
    end
end
