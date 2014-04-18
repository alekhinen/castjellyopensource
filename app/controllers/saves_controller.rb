class SavesController < ApplicationController
  before_action :set_save, only: [:show, :edit, :update, :destroy]

  # Get all subscriptions that the current_user is subscribed to
  # get /subscriptions
  def index 
    if current_user
      # Get all the subscriptions associated with the current_user
      # @subscriptions = Subscription.where(:user_id => current_user.id).order('created_at DESC')
      @saves = Save.where(:user_id => current_user.id).select(:show_id).to_sql
      @shows = Show.where("id IN (#{@saves})").order("updated_at DESC")
    else
      redirect_to root_url
    end
  end


  # GET /subscriptions/new
  def new
    @save = Save.new
  end


  # POST /subscriptions
  # POST /subscriptions.json
  def create
    @save = Save.new(save_params)

    respond_to do |format|
      if @save.save
        format.html { redirect_to @save, notice: 'Subscription was successfully created.' }
        format.json { render action: 'show', status: :created, location: @save }
      else
        format.html { render action: 'new' }
        format.json { render json: @save.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /subscriptions/1
  # DELETE /subscriptions/1.json
  def destroy
    @save.destroy
    respond_to do |format|
      format.html { redirect_to saves_url }
      format.json { head :no_content }
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_save
      @save = Save.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def save_params
      params.require(:save).permit(:user_id, :show_id)
    end
end