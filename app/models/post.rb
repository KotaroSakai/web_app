class Post < ApplicationRecord
	belongs_to :user
	has_many :likes

	validates :title, presence: true
	validates :content, presence: true

	def liked?(user)
		likes.where(user_id: user.id).exists?
	end
end
