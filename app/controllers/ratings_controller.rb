class RatingsController < ApplicationController
    skip_before_action :ensure_that_admin, only: [:destroy]
    
    def index
        @ratings = Rating.all
        @top_breweries = Brewery.top
        @top_beers = Beer.top
        @top_raters = Rating.top_raters
        @top_styles = Style.top
        @recent_ratings = Rating.recent(5)
    end
    
    def new
        @rating = Rating.new
        @beers = Beer.all
    end

    def edit
        @rating = Rating.find(params[:id])
        @beer_name = @rating.beer.name
    end

    def create
        request_path = request.env['PATH_INFO'] #tätä vois käyttää siihen, että ohjataan uuseri takaisin sille sivulle josta yritettiin reitata..
        #Rating.create params[:rating]
        #Rating.create beer_id:params[:rating][:beer_id], score:params[:rating][:score]
        
        #byebug

        #vain juuserit saa reitata
        unless current_user.nil?
            @rating = Rating.new params.require(:rating).permit(:score, :beer_id)
            if @rating.save
                current_user.ratings << @rating
                redirect_to current_user, notice: "You gave #{ @rating.beer.name } a rating of #{@rating.score} points."
            else
                @beers = Beer.all
                render :new
            end
        else 
            redirect_to signin_path, notice:'you should be signed in' 
        end
        
        #tallennetaan juuri tehty reittaus sessioon
        #session[:last_rating] = "#{rating.beer.name} #{rating.score} points"

        #@ratings = Rating.all
        #render :index
    end

    def destroy
        rating = Rating.find(params[:id])
        if current_user.nil? or current_user != rating.user
            redirect_to :back, notice:"You're not allowed to do that!"
        else
            rating.delete
            redirect_to :back, notice:"Rating successfully deleted."
        end
    end
end
