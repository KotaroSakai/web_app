namespace :line_notice do
	desc "LINEBOT: Smoking Record Notification" 
  task :push_line_message_task => :environment do
    client = Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
		today = Date.today
    users_without_smoking_records = User.joins(:send_set).where(send_set: { send_active: true}).where(role: :smoker).where.not(id: SmokeRecord.where("DATE(smoke_date) = ?", Date.today).pluck(:user_id))

    users_without_smoking_records.each do |user|
      user_notification_time = Time.current.change(hour: user.send_set.set_time.hour, min: user.send_set.set_time.min, sec: 0)

      if Time.current >= user_notification_time
        unless SendHistory.exists?(user_id: user.id, send_at: Date.today.in_time_zone('Tokyo').all_day, send_type_id: 1) # 当日の通知履歴があるか確認
          message = {
            type: 'text',
            text: "本日の喫煙記録がありません！"
          }
          response = client.push_message(user.uid, message)
          SendHistory.create(user_id: user.id, send_at: Date.today, send_type_id: 1) # 通知履歴を作成
          p response
        end
      end
    end
  end

  desc "LINEBOT: Smoking Record Notification Partner" 
  task :push_line_message_task_partner => :environment do
    client = Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
		today = Date.today
    # 本日の喫煙記録がないユーザーを取得
    users = User.where.not(id: SmokeRecord.where("DATE(smoke_date) = ?", Date.today).pluck(:user_id))
    # 喫煙記録がないユーザーのパートナーを取得
    partner_users = User.joins(:follows).joins(:followers).joins(:send_set).where(user_partners: { follower_id: users }).where(send_set: { send_active: true })

    partner_users.each do |user|
      user_notification_time = Time.current.change(hour: user.send_set.set_time.hour, min: user.send_set.set_time.min, sec: 0)
      if Time.current >= user_notification_time
        unless SendHistory.exists?(user_id: user.id, send_at: Date.today.in_time_zone('Tokyo').all_day, send_type_id: 1) # 当日の通知履歴があるか確認
          message = {
            type: 'text',
            text: "パートナーが本日の記録をしていません"
          }
          response = client.push_message(user.uid, message)
          SendHistory.create(user_id: user.id, send_at: Date.today) # 通知履歴を作成
          p response
        end
      end
    end
  end

  desc "LINEBOT: Smoking Record Notification Oneweek" 
  task :push_line_message_one_week => :environment do
    client = Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
    User.where.not(uid: nil, role: :partner).find_each do |user|
      if user.smoking_for_one_week? && !SendHistory.exists?(user_id: user.id, send_type_id: 2)
        message = {
          type: 'text',
          text: "おめでとうございます！1週間喫煙していませんね。これからもがんばってください！"
        }
        response = client.push_message(user.uid, message)
        SendHistory.create(user_id: user.id, send_at: Time.now, send_type_id: 2) # 通知履歴を作成
        p response
      elsif user.smoking_for_one_month? && !SendHistory.exists?(user_id: user.id, send_type_id: 3)
        message = {
          type: 'text',
          text: "おめでとうございます！1ヶ月間喫煙していませんね。これからもがんばってください！"
        }
        response = client.push_message(user.uid, message)
        SendHistory.create(user_id: user.id, send_at: Time.now, send_type_id: 3) # 通知履歴を作成
        p response
      end
    end
  end


end
