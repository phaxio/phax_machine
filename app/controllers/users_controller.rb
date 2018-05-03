class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :params_string_to_boolean, only: [:create, :update]

  def index
    @users = User.all.includes(:user_emails)
  end

  def new
    @user = User.new
    @user.user_emails.build
    @user.user_fax_numbers.build
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
    @user = User.new user_params

    if @user.save
      redirect_to users_path, notice: 'User added successfully.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update user_params
      redirect_to users_path, notice: 'User updated successfully.'
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to users_path, notice: 'User deleted successfully.'
  end

  private
  	def params_string_to_boolean
  		params[:user][:user_fax_numbers_attributes].each do |key, user_fax_number|
  			user_fax_number.has_key?("primary_number") ? user_fax_number["primary_number"] = true : user_fax_number["primary_number"] = false
  		end
  	end

    def user_params
      params.require(:user).permit( {user_fax_numbers_attributes: [:fax_number, :_destroy, :id, :user_id, :primary_number]}, {user_emails_attributes: [:email, :id, :_destroy]} )
    end

    def set_user
      @user ||= User.includes(:user_emails).find(params[:id])
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
        search_params[:'tag[user]'] = @user.fax_tag
      else
        search_params[:number] = @user.fax_number
      end
      search_params[:start] = params[:start].to_i if params[:start]
      search_params[:end] = params[:end].to_i if params[:end]
      search_params
    end
end
