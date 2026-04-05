class PasswordsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email]) ## or can be using name
    if user
      user.generate_password_reset_code!
      UserMailer.password_reset_code(user, user.password_reset_code).deliver_now
      redirect_to verify_code_path(user_id: user.id), notice: "Already sent an verification code email given that the account email exists."
    else
      redirect_to new_password_path, alert: "User not found, already sent an verification code email given that the account email exists."
    end
  end

  def edit # forms to enter the verfication code, previous to update()
    @user = User.find_by(id: params[:user_id])
    redirect_to new_password_path, alert: "Invalid request." unless @user&.password_reset_code  # invalid code or user not found
  end

  def update
    user = User.find_by(id: params[:user_id])
    if user && user.password_reset_code == params[:code] && user.password_reset_expires_at > Time.now
      redirect_to edit_user_password_path(user_id: user.id), notice: "Code verified. Please set your new password."
    else
      redirect_to verify_code_path(user_id: user.id), alert: "Invalid or expired code."
    end
  end
end
