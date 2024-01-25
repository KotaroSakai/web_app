namespace :line_notice do
	desc "LINEBOT: Smoking Record Notification" 
  task :push_line_message_task => :environment do
    client = Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
		today = Date.today
    users_without_smoking_records = User.joins(:send_set).where(send_set: { send_active: true}).where.not(id: SmokeRecord.where("DATE(smoke_date) = ?", Date.today).pluck(:user_id))

    users_without_smoking_records.each do |user|
      user_notification_time = Time.current.change(hour: user.send_set.set_time.hour, min: user.send_set.set_time.min, sec: 0)

      if Time.current >= user_notification_time
        message = {
          type: 'text',
          text: "本日の喫煙記録がありません！"
        }
        response = client.push_message(user.uid, message)
        p response
      end
    end
  end
end