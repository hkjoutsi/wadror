class SessionsController < ApplicationController
	def new
		#renderöi kirjautumissivun
	end

	def create
		#haetaan usernamea vastaava käyttäjä tietokannasta
		user = User.find_by username: params[:username]
		#talleetaan sessioon kirjautuneen käyttäjän id (jos olemassa)
		if user && user.authenticate(params[:password])
			session[:user_id] = user.id # unless user.nil? # unless = if not
			redirect_to user_path(user), notice: "Welcome back!" # = redirect_to user
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