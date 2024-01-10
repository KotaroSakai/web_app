namespace :line_notice do
	desc "LINEBOT: Smoking Record Notification" 
  task :push_line_message_task => :environment do
    client = Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
		
    users_without_smoking_records = User.where.not(id: SmokeRecord.where("DATE(smoke_date) = ?", Date.today).pluck(:user_id))

    users_without_smoking_records.each do |user|
      message = {
        type: 'text',
        text: "本日の喫煙記録がありません！"
      }
      response = client.push_message(user.uid, message)
      p response
    end
  end
end
