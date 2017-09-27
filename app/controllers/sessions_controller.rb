class SessionsController < ApplicationController
	include UsersHelper

	def new
		if logged_in?
      redirect_to "/users", notice: "You're already logged in as #{current_user.email}."
    else
      @user = User.new
      render :new
    end
	end

	def create
		if logged_in?
			redirect_to "/users", notice: "You're already logged in as #{current_user.email}."
		else
			@user = User.find_by(email: params[:login][:email])
	    if @user && @user.authenticate(params[:login][:password])
	      session[:user_id] = @user.id
	      redirect_to '/users', notice: "You've been logged in as #{current_user.email}"
	    else
	      redirect_to '/login', notice: "Login failed."
	    end
	  end
	end

	def destroy
		session.delete(:user_id)
		@current_user = nil
    redirect_to "/users", notice: "You have been logged out."
	end
end