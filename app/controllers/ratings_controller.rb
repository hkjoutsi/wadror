class RatingsController < ApplicationController
    def index
        @ratings = Rating.all
    end
    
    def new
        @rating = Rating.new
        @beers = Beer.all
    end

    def create
        #Rating.create params[:rating]
        #Rating.create beer_id:params[:rating][:beer_id], score:params[:rating][:score]

        #vain juuserit saa reitata
        unless current_user.nil?
            @rating = Rating.create params.require(:rating).permit(:score, :beer_id)
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
