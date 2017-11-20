class UsersController < ApplicationController
  def edit
    
  end
  def update
    respond_to do |format|
      if @current_user.update(user_params)
        format.html { redirect_to my_account_path, notice: 'Account was successfully updated.' }
        format.json { render :show, status: :ok, location: @current_user }
      else
        format.html { render :edit }
        format.json { render json: @current_user.errors, status: :unprocessable_entity }
      end
    end
  end
  
  private
  def user_params
    params.require(:user).permit(:password,:password_confirmation)
  end
end
