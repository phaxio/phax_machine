class SessionsController < ApplicationController
	def new
		@user = User.new
	end

	def create
		@user = User.find_by(email: params[:login][:email])
    if @user && @user.authenticate(params[:login][:password])
      session[:user_id] = @user.id
      redirect_to '/users'
    else
      render :new
    end
	end

	def destroy
		session.delete(:user_id)
		@current_user = nil
    redirect_to "/users"
	end
end