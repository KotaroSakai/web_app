class UsersController < ApplicationController
  before_action :authenticate_user!
  def show
    @user = User.find(params[:id])

    if @user.role == "partner"
      @user_partner = @user.followers
    else
      @user_partner = @user.follows
    end

    @smoke_record = SmokeRecord.new
    @send_set = current_user.send_set
  end

  def enter_token
  end

  def validata_token
    user = User.find_by_token(params[:token])
    if user.present?
      if current_user == user
        redirect_to enter_token_user_path, danger: "対応するユーザーがいません"
      elsif current_user.following?(user)
        redirect_to enter_token_user_path, danger: "すでにパートナーになっています"
    
      else
        unless UserPartner.exists?(follower_id: current_user.id, followed_id: user.id)
          UserPartner.create(followed_id: user.id, follower_id: current_user.id)
          redirect_to user_path, notice: "フォロー関係を保存しました"
        else
          redirect_to enter_token_user_path, alert: "すでにパートナーになっています"
        end
      end
    else
      redirect_to enter_token_user_path, notice: "対応するユーザーがいません"
    end
  end

  def remove_partner
    followed_id = params[:followed_id]
    partner = User.find(followed_id)
    UserPartner.find_by(follower_id: current_user.id, followed_id: followed_id).destroy
    redirect_to user_path(current_user), success: "関係を解除しました"
    
  end

  private
  
  def user_params
    params.require(:user).permit(:name, :email, :role)
  end
end
