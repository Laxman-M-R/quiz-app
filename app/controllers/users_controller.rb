class UsersController < ApplicationController
  def users_page
    @users = User.all
  end

  def new
    @user = User.new    
  end

  def create
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        format.html { redirect_to users_users_page_url, notice: 'User was successfully created.' }       
      end
    end
  end

  def change_user_role    
    @user = User.find(params[:id])
    # if user is updated successfully then redirect
    if(@user.update_attributes(user_params))
      respond_to do |format|
        format.html { redirect_to users_users_page_url, notice: 'Role changed successfully' }
      end
    end
  end



  def destroy
    @user = User.find(params[:id])
    if @user.destroy
        redirect_to root_url, notice: "User deleted."
    end
  end

  # new method added to allow specific attributes only and discarding other malicious attributes that user may send
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :admin)
  end
end