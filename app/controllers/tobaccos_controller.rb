class TobaccosController < ApplicationController
before_action :set_tabacco, only: [:show, :update, :destroy]

  def new
    @tobacco = Tobacco.new
  end

  def create
    @tobacco = current_user.build_tobacco(tobacco_params)
    if @tobacco.save
      redirect_to tobacco_path(@tobacco)
    else
      render :new
    end
  end

  def show
  end

  def edit
    if current_user.tobacco.present?
      set_tabacco
    else
      redirect_to new_tobacco_path
    end

  end

  def update
    if @tobacco.update(tobacco_params)
      redirect_to user_path(current_user), success: "変更が完了しました"
    else
      render :edit
    end
  end

  private

  def tobacco_params
    params.require(:tobacco).permit(:price, :baseline_cigarette)
  end

  def set_tabacco
    @tobacco = current_user.tobacco
  end
end
