class PodcastsController < ApplicationController
  before_action :set_podcast, only: [:show, :edit, :update, :destroy]


  #############################################################################
  ## Default Methods ##########################################################
  #############################################################################
  # GET /podcasts
  # GET /podcasts.json
  def index
    if params[:search]
        @podcasts = Podcast.search(params[:search]).order("created_at DESC")
      else
        @podcasts = Podcast.all.order('created_at DESC')
      end
  end


  # GET /podcasts/1
  # GET /podcasts/1.json
  def show
    # Get shows associated with this podcast
    @shows = Show.where(:podcast_id => params[:id]).order('published_at DESC')
    # Paginate the @shows array
    @shows = Kaminari.paginate_array(@shows).page(params[:page]).per(20)
  end


  # GET /podcasts/new
  def new
    if current_user.admin
      @podcast = Podcast.new
    else
      redirect_to root_url
    end
  end


  # GET /podcasts/1/edit
  def edit
  end


  # POST /podcasts
  # POST /podcasts.json
  def create
    if current_user.admin
      # Get the rss_link POST data and fetch and parse that link
      @feed = Feedjira::Feed.fetch_and_parse(params[:podcast][:rss_link])
      # @feed = Feedjira::Feed.fetch_raw(params[:podcast][:rss_link])
      # @feed = Feedjira::Parser::ITunesRSS.parse(@feed)


      # Create a new Podcast
      @podcast = Podcast.new(:title         => @feed.title, 
                             :description   => @feed.itunes_summary, 
                             :link          => @feed.url, 
                             :rss_link      => @feed.feed_url, 
                             :tags          => @feed.itunes_keywords,
                             :image         => URI.parse(@feed.itunes_image),
                             :last_modified => @feed.last_modified)

      # @podcast = Podcast.new(podcast_params)

      respond_to do |format|
        if @podcast.save
          ShowsController.update_from_feed(@podcast.rss_link, @podcast.id)
          format.html { redirect_to @podcast, notice: 'Podcast was successfully created.' }
          format.json { render action: 'show', status: :created, location: @podcast }
        else
          format.html { render action: 'new' }
          format.json { render json: @podcast.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to root_url
    end
  end

  # PATCH/PUT /podcasts/1
  # PATCH/PUT /podcasts/1.json
  def update
    if current_user.admin
      # Get the rss_link POST data and fetch and parse that link
      @feed = Feedjira::Feed.fetch_and_parse(params[:podcast][:rss_link])

      respond_to do |format|
        # if @podcast.update(podcast_params)
        if @podcast.update(:title         => @feed.title, 
                           :description   => @feed.itunes_summary, 
                           :link          => @feed.url, 
                           :rss_link      => @feed.feed_url, 
                           :tags          => @feed.itunes_keywords,
                           :image         => URI.parse(@feed.itunes_image),
                           :last_modified => @feed.last_modified)
          ShowsController.update_from_feed(@podcast.rss_link, @podcast.id)
          format.html { redirect_to @podcast, notice: 'Podcast was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: 'edit' }
          format.json { render json: @podcast.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to root_url
    end
  end


  # DELETE /podcasts/1
  # DELETE /podcasts/1.json
  def destroy
    if current_user.admin
      @podcast.destroy
      respond_to do |format|
        format.html { redirect_to podcasts_url }
        format.json { head :no_content }
      end
    else
      redirect_to root_url
    end
  end





  #############################################################################
  ## Additional Methods #######################################################
  #############################################################################

  # Create subscription relationship between current user and podcast
  # POST /podcasts/:id
  # NOTE: I would like to move these methods over to subscriptions_controller
  def subscribe
    @podcast = Podcast.where(:id => params[:id]).first
    unless Subscription.where(:user_id => current_user.id, :podcast_id => params[:id]).size > 0
      @subscription = Subscription.new(:user_id => current_user.id, :podcast_id => params[:id])
      if @subscription.save
        puts "Subscription successfully created!"
        redirect_to @podcast, :notice => "successfully subscribed!"
        # render :layout => false
      else
        puts "Subscription failed to be created!"
        render :layout => false
      end
    end
  end


  # Refresh a specific podcast's shows.
  # PATCH/PUT /podcasts/:id/refresh
  def refresh
    @podcast = Podcast.find_by_id(params[:id])
    puts "this is"
    ShowsController.update_from_feed(@podcast.rss_link, @podcast.id)
    puts "some straight"
    respond_to do |format|
      puts "bullshit"
      format.html { redirect_to @podcast, notice: 'Podcast successfully refreshed!'}
      format.json { head :no_content }
    end
  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_podcast
      @podcast = Podcast.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def podcast_params
      params.require(:podcast).permit(:title, :description, :link, :rss_link, :tags, :views, :created_at)
    end
end
