class SmokeRecordsController < ApplicationController
  before_action :set_smoke_record, only: [:show, :edit, :update, :destroy]

  def index
    @smoke_records = current_user.smoke_records
    @smoke_record = SmokeRecord.new

    @data = SmokeRecord.group_by_day(:smoke_date, time_zone: 'Tokyo').sum(:smoked)

    

    if @smoke_records.presence && current_user.tobacco.presence
      @total_smoked = current_user.smoke_records.sum(:smoked)
      @cost = calculate_cost(@total_smoked)
      #@smoke_count_date = @smoke_records.group_by_day(:smoke_date).count
    end

    
  end

  def new
    @smoke_record = SmokeRecord.new
  end

  def create
    @smoke_record = current_user.smoke_records.build(smoke_record_params)

    if @smoke_record.save
      redirect_to smoke_records_path, success: "記録しました"
    else
      render :new
      flash[:alert] = "記録できませんでした"
    end
  end

  def edit
  end

  def show
  end

  def destroy
    @smoke_record.destroy
    redirect_to smoke_records_path, danger: "喫煙記録を削除しました"
  end


  private

  def smoke_record_params
    params.require(:smoke_record).permit(:smoke_date, :smoked)
  end

  def set_smoke_record
    @smoke_record = current_user.smoke_records.find(params[:id])
  end

  def calculate_cost(total_smoked)
    price = current_user.tobacco.price
    one_price = price / 20
    total_price = one_price * total_smoked
    total_price
  end
end
