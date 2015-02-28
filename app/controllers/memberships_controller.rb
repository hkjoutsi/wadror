class MembershipsController < ApplicationController
  before_action :set_membership, only: [:show, :edit, :update]
  before_action :set_beer_clubs_for_template, only: [:new, :edit, :create]
  skip_before_action :ensure_that_admin, only: [:destroy, :toggle_confirmed]

  # GET /memberships
  # GET /memberships.json
  def index
    @memberships = Membership.all
  end

  # GET /memberships/1
  # GET /memberships/1.json
  def show
  end

  # GET /memberships/new
  def new
    @membership = Membership.new
    #@beer_clubs = BeerClub.all.reject{ |b| b.members.include? current_user }
    #in membership model also the following: validates_uniqueness_of :user_id, scope: :beer_club_id
  end

  # GET /memberships/1/edit
  def edit
  end

  def toggle_confirmed
    toConfirm = Membership.find_by_id(params[:id])
    unless toConfirm.nil? || toConfirm.confirmed
      toConfirm.confirmed=true;
      toConfirm.save;
      redirect_to :back, notice: "Membership confirmed!"
    else
      redirect_to :back, alert: "Woops, Something went wrong."
    end
    
  end

  # POST /memberships
  # POST /memberships.json
  def create
    unless current_user.nil?
      #mallissa:
      #@membership = Membership.new(membership_params)
      #@membership.user = current_user
      @membership = Membership.new params.require(:membership).permit(:beer_club_id)
      @membership.user = current_user
      @membership.confirmed = false

      respond_to do |format|
        if @membership.save
          format.html { redirect_to @membership.beer_club, notice: "You're application for #{@membership.beer_club.name} has been sent! Sit still and wait for confirmation." }
          format.json { render :show, status: :created, location: @membership }
        else
          format.html { render :new }
          format.json { render json: @membership.errors, status: :unprocessable_entity }
        end
      end  
    else raise #kirjautumaton juuseri yrittää liittyä klubiin
    end  
  end

  # PATCH/PUT /memberships/1
  # PATCH/PUT /memberships/1.json
  def update
    respond_to do |format|
      if @membership.update(membership_params)
        format.html { redirect_to @membership, notice: 'Membership was successfully updated.' }
        format.json { render :show, status: :ok, location: @membership }
      else
        format.html { render :edit }
        format.json { render json: @membership.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /memberships/1
  # DELETE /memberships/1.json
  def destroy
    #if requests comes from a different path, search by the information provided
    current_uri = request.env['PATH_INFO']
    if current_uri == "/memberships"
      beer_club_id = params[:membership][:beer_club_id]
      @membership =  Membership.find_by_beer_club_id_and_user_id(beer_club_id, current_user.id)
    end

    #else we assume, that the delete request came from the usual place, memberships/:id
    unless current_user.nil? or current_user!=@membership.user

      @membership.destroy
      respond_to do |format|
        #byebug
        format.html { redirect_to current_user, notice: "Your membership in #{@membership.beer_club.name} ended." }
        format.json { head :no_content }
      end
    else
      redirect_to memberships_url, notice: "You aren't allowed to touch other users memberships! You bastard."
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_membership
      @membership = Membership.find(params[:id])
    end

    def set_beer_clubs_for_template
      @beer_clubs = BeerClub.all.reject{ |b| b.members.include? current_user }
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def membership_params
      params.require(:membership).permit(:beer_club_id, :user_id)
    end
end
