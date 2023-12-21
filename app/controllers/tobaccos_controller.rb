class TobaccosController < ApplicationController
  def new
    @tobacco = Tobacco.new
  end

  def create
    @tobacco = current_user.tobacco.build(tobacco_params)
    if @tobacco.save
      redirect_to users_psth
    else
      render :new
    end
  end

  def show
    @tobacco = current_user.tobacco
  end

  private

  def tobacco_params
    params.require(:tobacco).permit(:price, :baseline_cigarette)
  end
end
