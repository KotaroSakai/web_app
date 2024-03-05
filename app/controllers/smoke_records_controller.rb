class SmokeRecordsController < ApplicationController
  before_action :set_smoke_record, only: [:show, :edit, :update, :destroy]

  def index
    @smoke_records = current_user.smoke_records
    @smoke_record = SmokeRecord.new
    
    # @toral_smoked 設定した期間の喫煙数
    # @cost 設定した期間の喫煙にかかった金額
    # @saved_cost 設定した期間の節約した金額
    # @saved_life 設定した期間の伸びた寿命
    if @smoke_records.presence && current_user.tobacco.presence
      duration = params[:duration]
      @total_smoked = calculate_total_smoked(duration)
      @cost = calculate_cost(@total_smoked)
      @saved_cost = savings(duration)
      @saved_life = life_calculation(duration)
    end

    if current_user.role == "smoker"
      @data = case duration
      when "7"
        current_user.smoke_records.where("smoke_date >= ?", 1.week.ago).group_by_day(:smoke_date).sum(:smoked).to_a
      when '30'
        current_user.smoke_records.where("smoke_date >= ?", 1.month.ago).group_by_week(:smoke_date).sum(:smoked).to_a
      else
        current_user.smoke_records.where("smoke_date >= ?", 1.year.ago).group_by_month(:smoke_date).sum(:smoked).to_a
      end
    else
      partner_id = UserPartner.find_by(follower_id: current_user.id)
      user = User.find(partner_id.followed_id)
      @data = case duration
      when "7"
        user.smoke_records.where("smoke_date >= ?", 1.week.ago).group_by_day(:smoke_date).sum(:smoked).to_a
      when '30'
        user.smoke_records.where("smoke_date >= ?", 1.month.ago).group_by_week(:smoke_date).sum(:smoked).to_a
      else
        user.smoke_records.where("smoke_date >= ?", 1.year.ago).group_by_month(:smoke_date).sum(:smoked).to_a
      end
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

  def calculate_cost(total_smoked) #総喫煙数 X 一本の値段
    tobacco = set_tobacco
    price = set_tobacco.price
    one_price = price / 20
    total_price = one_price * total_smoked
    total_price
  end

  def savings(duration) # 節約金額計算
    tobacco = set_tobacco
    start_date, end_date, days_multiplier = calculate_duration(duration)
    
    one_price = price_of_one

    smoke_records = SmokeRecord.where(user_id: current_user.id, smoke_date: start_date..end_date)
    base = current_user.tobacco.baseline_cigarette
    base_cost = base * days_multiplier
    smoke_in_period = smoke_records.sum(:smoked)

    smoking = base_cost - smoke_in_period
    saved_cost = smoking * one_price
    saved_cost
  end

  def life_calculation(duration) #寿命の計算
    tobacco = set_tobacco
    start_date, end_date, days_multiplier = calculate_duration(duration)
    base_time = 5

    smoke_records = SmokeRecord.where(user_id: current_user.id, smoke_date: start_date..end_date)
    base = current_user.tobacco.baseline_cigarette
    base_cost = base * days_multiplier
    smoke_in_period = smoke_records.sum(:smoked)

    smoking = base_cost - smoke_in_period
    saved_life = smoking * base_time
    
    if saved_life > 1440 # 24 * 60 (1日の分数)
      days = saved_life / 1440
      hours_remainder = (saved_life % 1440) / 60
      minutes_remainder = (saved_life % 1440) % 60
      formatted_result = "#{days}日間 #{hours_remainder}時間 #{minutes_remainder}分"
    elsif saved_life > 60 # 1時間を超える場合は時間と分に分割
      hours = saved_life / 60
      minutes_remainder = saved_life % 60
      formatted_result = "#{hours}時間 #{minutes_remainder}分"
    else
      formatted_result = "#{saved_life}分"
    end
  
    formatted_result
  end

  def set_tobacco # ユーザーのタバコ情報を取得
    Tobacco.find_by(user_id: current_user.id)
  end

  def price_of_one #一本の値段計算
    tobacco = set_tobacco
    tobacco.price / 20
  end

  def calculate_duration(duration) #日数の計算
    end_date = Date.current

    case duration
    when '7'
      start_date = end_date - 6.days
      days_multiplier = 7
    when '30'
      start_date = end_date - 29.days
      days_multiplier = 30
    when 'all'
      first_smoke_date = current_user.smoke_records.minimum(:smoke_date)
      start_date = first_smoke_date || Date.current
      days_multiplier = (Date.current - start_date).to_i + 1
    else
      start_date = end_date - 6.days # デフォルトは1週間
      days_multiplier = 7
    end

    [start_date, end_date, days_multiplier]
  end

  def calculate_total_smoked(duration)
    start_date, end_date, _ = calculate_duration(duration)
    smoke_records = SmokeRecord.where(user_id: current_user.id, smoke_date: start_date..end_date)
    smoke_records.sum(:smoked)
  end

  


end
