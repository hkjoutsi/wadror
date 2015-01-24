class RatingsController < ApplicationController
    def index
        @ratings = Rating.all
    end
    
    def new
        @rating = Rating.new
        @beers = Beer.all
    end

    def create
    	#byebug
    	#raise
    	#Rating.create params[:rating]
    	#Rating.create beer_id:params[:rating][:beer_id], score:params[:rating][:score]
    	Rating.create params.require(:rating).permit(:score, :beer_id)
    	redirect_to ratings_path
    	#@ratings = Rating.all
    	#render :index
    end
end
