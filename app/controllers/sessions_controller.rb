class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(name: params[:name].downcase)

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to items_path, notice: "Welcome back, #{user.name}! ✨"
    else
      redirect_to login_path, alert: "Invalid name or password! Please enter again."
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path, notice: "You have been logged out. See you soon! 👋"
  end
  # similar to password_controller, edit and update password
  def edit
    @user = User.find_by(id: params[:user_id])
    rediect_to new_password_path, alert: "Invalid request." unless @user&.password_reset_code
  end

  def update
    @user = User.find_by(id: params[:user_id])
    if @user && @user.password_reset_code && @user.password_reset_expires_at > Time.now
      if @user.update(password: params[:user][:password], password_confirmation: params[:user][:password_confirmation])
        @user.clear_password_reset_code! # Clear the code after successful reset
        redirect_to login_path, notice: "Your password has been reset successfully. Please log in."
      else
        render :edit, status: :unprocessable_entity
      end
    else
      redirect_to new_password_path, alert: "Invalid or expired request."
    end
  end

end