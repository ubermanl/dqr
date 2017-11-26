class UsersController < ApplicationController
  before_action :require_admin, only: [:index,:destroy,:new,:create]
  before_action :set_user, only: [:edit,:update, :show]
  
  def new
    @user = User.new
  end
  
  def index
    @users = User.all
  end
  def edit
    
  end
  
  def create
    @user = purge_rights(User.new(user_params))
    respond_to do |format|
      if @user.save
        format.html { redirect_to users_path, notice: 'Account was successfully created.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def update
    @user.assign_attributes(user_params)
    @user = purge_rights(@user)
    respond_to do |format|
      if @user.save
        format.html { redirect_to edit_user_url(@user), notice: 'Account was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
  
  private
  def user_params
    params.require(:user).permit(:login, :name,:mail, :role,:active, :password,:password_confirmation, device_module_ids: [] )
  end
  
  def set_user
    if params[:login] && current_user.admin?
      @user = User.find(params[:login])
    else
      @user = current_user
    end
  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'User not found'
    redirect_to users_url
  end
  
  def purge_rights(user)
    Rails.logger.info "////////////////// #{user.active_was} / #{user.role_was} / #{current_user.name} / #{current_user.admin?}"
    if (current_user.role_was == 1 && current_user.login == user.login) || (!current_user.admin?)
      # revert
      user.active = user.active_was
      user.role = user.role_was
    end
    user
  end
end
