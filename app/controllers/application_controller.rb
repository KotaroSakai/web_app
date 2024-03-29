class ApplicationController < ActionController::Base
	before_action :configure_permitted_parameters, if: :devise_controller?
	add_flash_types :success, :info, :warning, :danger
	def configure_permitted_parameters
    # 新規登録時(sign_up時)にnameとroleというキーのパラメーターを追加で許可する
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :role]) 
  end

	def after_sign_in_path_for(resource)
		user_path(current_user)
	end

	private

	def authenticate_user!
    unless user_signed_in?
			redirect_to new_user_session_path, danger: "ログインしてください"
		end
  end
end
