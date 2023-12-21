class SmokeRecordsController < ApplicationController
  def new
    @smoke_record = SmokeRecord.new
  end

  def create
    @smoke_record = current_user.smoke_records.build(smoke_record_params)

    if @smoke_record.save
      redirect_to root_path, notice: "記録しました"
    else
      render :new
    end
  end

  def edit
  end

  private

  def smoke_record_params
    params.require(:smoke_record).permit(:smoke_date, :smoked)
  end
end
