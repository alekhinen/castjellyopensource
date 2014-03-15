class PodcastsController < ApplicationController
  before_action :set_podcast, only: [:show, :edit, :update, :destroy]

  # GET /podcasts
  # GET /podcasts.json
  def index
    @podcasts = Podcast.all
  end

  # GET /podcasts/1
  # GET /podcasts/1.json
  def show
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
      @podcast = Podcast.new(podcast_params)

      respond_to do |format|
        if @podcast.save
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
      respond_to do |format|
        if @podcast.update(podcast_params)
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_podcast
      @podcast = Podcast.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def podcast_params
      params.require(:podcast).permit(:title, :description, :link, :tags, :views, :created_at)
    end
end
