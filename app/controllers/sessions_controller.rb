class SessionsController < ApplicationController
	skip_before_action :ensure_that_signed_in, only: [:new, :create]
	skip_before_action :ensure_that_admin, only: [:destroy]
	
	def new
		#renderöi kirjautumissivun
	end

	def create
		#haetaan usernamea vastaava käyttäjä tietokannasta
		user = User.find_by username: params[:username]
		#talleetaan sessioon kirjautuneen käyttäjän id (jos olemassa)
		if user && user.authenticate(params[:password]) and not user.disabled?
			session[:user_id] = user.id # unless user.nil? # unless = if not
			redirect_to user_path(user), alert: "Welcome back!" # = redirect_to user
		elsif user.disabled?
			redirect_to :back, notice: "The account for #{params[:username]} has been frozen! Please contact an administrator."
		else
			redirect_to :back, notice: "User #{params[:username]} does not exist OR you gave the wrong password!"
		end

	end

	def destroy
		#nollataan sessio
		session[:user_id] = nil
		redirect_to :root
	end

end
