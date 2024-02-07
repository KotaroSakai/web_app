class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @user_partner = @user.follows

    @smoke_record = SmokeRecord.new
    @send_set = current_user.send_set
  end

  def enter_token
  end

  def validata_token
    user = User.find_by_token(params[:token])
    if user.present?
      if current_user.following?(user)
        redirect_to enter_token_user_path, alert: "すでにパートナーになっています"
    
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

  private
  
  def user_params
    params.require(:user).permit(:name, :email)
  end
end
