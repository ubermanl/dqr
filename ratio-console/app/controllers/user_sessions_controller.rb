class UserSessionsController < ApplicationController
  layout 'login'
  
  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(user_session_params)
    if @user_session.save
      flash[:success] = "Welcome back!"
      redirect_to root_path
    else
      render :new
    end
  end

  def destroy
    current_user_session.destroy if current_user_session
    flash[:success] = "Goodbye!"
    redirect_to root_path
  end

  private

  def user_session_params
    params.require(:user_session).permit(:login, :password, :remember_me)
  end
end