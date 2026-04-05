class UsersController < ApplicationController
  before_action :set_user, only: %i[ show ]

  def index
    @users = User.all
  end
  def show
  end

  def new
    @user = User.new
  end

  def create
    new_user_params = user_params()
    @user = User.new(new_user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to login_path, notice: "User was successfully created!" }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :email, :location, :password, :password_confirmation)
    end
end
