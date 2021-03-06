class BreweriesController < ApplicationController
  before_action :set_brewery, only: [:show, :edit, :update, :destroy]
  #before_action :authenticate, only: [:destroy]
  skip_before_action :ensure_that_signed_in, only: [:list]
  #skip_before_action :ensure_that_signed_in, only: [:list, :nglist]

  before_action :skip_if_cached, only:[:index]
  before_action :expire_brewerylist, only:[:create, :update, :destroy]

  # GET /breweries
  # GET /breweries.json
  def index
    #if ascending flag not yet set or false make it true, else false
    #session[:asc] = (session[:asc].nil? || session[:asc]==false) ? true : false
#    byebug
    @active_breweries = Brewery.active
    @retired_breweries = Brewery.retired
    
    #order = params[:order] || 'name'
    #ascending = session[:asc]

    @active_breweries = case @order
      when 'name' then
        #byebug
        #ascending ? @active_breweries.sort_by{ |b| b.name } : @active_breweries.sort_by{ |b| b.name }.reverse!
        @active_breweries.sort_by{ |b| b.name.downcase }
      when 'year' then
        #ascending ? @active_breweries.sort_by{ |b| b.year } :  @active_breweries.sort_by{ |b| b.year }.reverse!
        @active_breweries.sort_by{ |b| b.year }
    end

    @retired_breweries = case @order
      when 'name' then
        #byebug
        #ascending ? @retired_breweries.sort_by{ |b| b.name } : @retired_breweries.sort_by{ |b| b.name }.reverse!
        @retired_breweries.sort_by{ |b| b.name.downcase }
      when 'year' then
        #ascending ? @retired_breweries.sort_by{ |b| b.year } :  @retired_breweries.sort_by{ |b| b.year }.reverse!
        @retired_breweries.sort_by{ |b| b.year }
    end

  end

  def list
    @breweries = Brewery.all
  end

  # GET /breweries/1
  # GET /breweries/1.json
  def show
  end

  # GET /breweries/new
  def new
    @brewery = Brewery.new
  end

  # GET /breweries/1/edit
  def edit
  end

  # POST /breweries
  # POST /breweries.json
  def create
    @brewery = Brewery.new(brewery_params)

    respond_to do |format|
      if @brewery.save
        format.html { redirect_to @brewery, notice: 'Brewery was successfully created.' }
        format.json { render :show, status: :created, location: @brewery }
      else
        format.html { render :new }
        format.json { render json: @brewery.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /breweries/1
  # PATCH/PUT /breweries/1.json
  def update
    respond_to do |format|
      if @brewery.update(brewery_params)
        format.html { redirect_to @brewery, notice: 'Brewery was successfully updated.' }
        format.json { render :show, status: :ok, location: @brewery }
      else
        format.html { render :edit }
        format.json { render json: @brewery.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /breweries/1
  # DELETE /breweries/1.json
  def destroy
    @brewery.destroy
    respond_to do |format|
      format.html { redirect_to breweries_url, notice: 'Brewery was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def toggle_activity
    brewery = Brewery.find(params[:id])
    brewery.update_attribute :active, (not brewery.active)

    new_status = brewery.active? ? "active" : "retired"

    redirect_to :back, notice:"brewery activity status changed to #{new_status}"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_brewery
      @brewery = Brewery.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def brewery_params
      params.require(:brewery).permit(:name, :year, :active)
    end

    def expire_brewerylist
      #expire_fragment('brewerylist')
      #brewerylist-#{@order}
      ["brewerylist-name", "brewerylist-year"].each{ |f| expire_fragment(f) }
    end

    def skip_if_cached
      #byebug
      @order = params[:order] || 'name'
      return render :index if fragment_exist?( "brewerylist-#{@order}"  )
    end

  # HUOM: älä kirjoita private-määrettä tiedostoon ennen kontrollerimetodeja (index, new, ...)

#  def authenticate
#      #raise "toteuta autentikointi"
#      admin_accounts = { "admin" => "secret", "pekka" => "beer", "heta" => "kissa", "muita" => "pareja"}
#      authenticate_or_request_with_http_basic do |username, password|
#        #username == "admin" and password == "secret"
#        admin_accounts.has_key?(username) and admin_accounts[username] == password
#      end
 # end

end
