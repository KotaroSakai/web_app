class SendSetsController < ApplicationController
	before_action :set_setting, only: [:show, :edit, :update]

	def new
		@send_set = SendSet.new
	end

	def create
		@send_set = current_user.build_send_set(send_set_params)
		if @send_set.save
			redirect_to send_set_path(@send_set)
		else
			render :new
		end
	end
	
	def show
	end

	def edit
		if current_user.send_set.nil?
			redirect_to new_send_set_path
		end
	end

	def update
		if @send_set.update(send_set_params)
			redirect_to @send_set, success: "設定を更新しました"
		else
			render :edit
		end
	end

	private

	def set_setting
		@send_set = current_user.send_set
	end

	def send_set_params
		send_active_value = ActiveRecord::Type::Boolean.new.cast(params[:send_set][:send_active])
		puts "send_active_value: #{send_active_value.inspect}"
		params.require(:send_set).permit(:set_time, :send_active).merge(send_active: send_active_value)
	end
end
