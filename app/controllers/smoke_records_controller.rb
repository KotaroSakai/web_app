class SmokeRecordsController < ApplicationController
  before_action :set_smoke_record, only: [:show, :edit, :update, :destroy, :show]

  def index
    @smoke_records = current_user.smoke_records.all
  end

  def new
    @smoke_record = SmokeRecord.new
  end

  def create
    @smoke_record = current_user.smoke_records.build(smoke_record_params)

    if @smoke_record.save
      redirect_to root_path, notice: "記録しました"
    else
      flash[:alert] = "記録できませんでした"
      render :new
    end
  end

  def edit
  end

  def show
  end

  def destroy
    @smoke_record.destroy
    redirect_to smoke_records_path, notice: "喫煙記録を削除しました"
  end


  private

  def smoke_record_params
    params.require(:smoke_record).permit(:smoke_date, :smoked)
  end

  def set_smoke_record
    @smoke_record = current_user.smoke_records.find(params[:id])
  end
end
