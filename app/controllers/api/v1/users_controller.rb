class Api::V1::UsersController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :ensure_normal_user, only: %i[update destroy]
  def index
    @users = User.all
    render json: @users.as_json(only: [:id, :name, :email, :created_at])
  end

  def show
    @user = User.find(params[:id])
    render json: @user.as_json(only: [:id, :name, :email, :created_at])
  end

  def edit
    @user = User.find(params[:id])
    return redirect_to users_path, alert: '不正なアクセスです。' if !(current_user.admin? || @user == current_user)
  end

  def update
    @user = User.find(params[:id])
    return redirect_to user_path(@user), notice: '投稿に成功しました。' if @user.update(user_params)

    render :edit
  end

  def destroy
    @user = User.find(params[:id]).destroy
    render json: { status: 'SUCCESS', message: 'ユーザー情報を削除しました。', data: @user }
    # flash[:success] = "ユーザー情報を削除しました。"
    redirect_to users_path
  end

  def ensure_normal_user
    if params[:user][:email].downcase == 'guest@example.com'
      redirect_to root_path, alert: 'ゲストユーザーの更新・削除はできません。'
    end
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :profile, :profile_image)
    end
end
