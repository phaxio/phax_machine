class UsersController < ApplicationController
  include UsersHelper

  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.all
  end

  def new
    if logged_in?
      redirect_to users_path, notice: 'Please log out to add a new user.'
    else
      @user = User.new
      render :new
    end
  end

  def show
    respond_to do |format|
      format.html do
        render :show
      end
      format.json do
        render json: get_user_faxes
      end
    end
  end

  def create
    if logged_in?
      redirect_to users_path, notice: 'Please log out to add a new user.'
    else
      @user = User.new user_params

      if @user.save
        session[:user_id] = @user.id
        redirect_to users_path, notice: 'User added successfully.'
      else
        render :new
      end
    end
  end

  def edit
    if authorized?
      render :edit
    else
      redirect_to users_path, notice: 'You cannot edit other users.'
    end
  end

  def update
    if authorized?
      if @user.update user_params
        redirect_to users_path, notice: 'User updated successfully.'
      else
        render :edit
      end
    else
      redirect_to users_path, notice: 'You cannot edit other users.'
    end
  end

  def destroy
    if authorized?
      @user.destroy
      redirect_to users_path, notice: 'User deleted successfully.'
    else
      redirect_to users_path, notice: 'You cannot delete other users.'
    end
  end

  private

    def user_params
      params.require(:user).permit(:email, :fax_number, :password, :password_confirmation)
    end

    def set_user
      @user ||= User.find(params[:id])
    end

    def get_user_faxes
      received_faxes = Phaxio.list_faxes(search_params(:received))
      sent_faxes = Phaxio.list_faxes(search_params(:sent))

      error_responses = [received_faxes, sent_faxes].select { |response| !response['success'] }
      if error_responses.present?
        return error_responses.first
      end

      {
        success: received_faxes['success'],
        message: received_faxes['message'],
        data: (received_faxes['data'] + sent_faxes['data'])
          .uniq { |f| f['id'] }
          .sort { |a, b| b['requested_at'] <=> a['requested_at'] },
        totals: {
          sent: sent_faxes['paging']['total_results'],
          received: received_faxes['paging']['total_results']
        }
      }
    end

    def search_params(direction)
      search_params = {}
      if direction == :sent
        search_params[:'tag[user]'] = @user.email
      else
        search_params[:number] = @user.fax_number
      end
      search_params[:start] = params[:start].to_i if params[:start]
      search_params[:end] = params[:end].to_i if params[:end]
      search_params
    end

    def authorized?
      if set_user && current_user
        set_user.id == current_user.id ? true : false
      end
    end
end
