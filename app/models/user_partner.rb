class UserPartner < ApplicationRecord
	belongs_to :followed, class_name: "User" # コードを入力してもらうユーザー
	belongs_to :follower, class_name: "User" # コードを入力したユーザー
end
