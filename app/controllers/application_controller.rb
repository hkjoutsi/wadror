class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :ensure_that_signed_in, except: [:index, :show]
  before_action :ensure_that_admin, only: [:destroy]

  #määritellään, että metodi current_user tulee käyttöön myös näkymissä
  helper_method :current_user
  helper_method :is_admin

  def current_user
  	return nil if session[:user_id].nil?
  	
    if User.where(id: session[:user_id]).empty? #just in case?
  		session[:user_id] = nil
  		return nil
  	else return User.find(session[:user_id])
  	end
  end

  def is_admin
    return current_user.admin?
  end

  def ensure_that_signed_in
    redirect_to signin_path, notice: 'you should be signed in' if current_user.nil?
  end

  def ensure_that_admin
    redirect_to signin_path, notice: 'You need admin rights to do that.' if current_user.nil? or current_user.admin != true
  end

end
