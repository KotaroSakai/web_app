class SmokeRecord < ApplicationRecord
  belongs_to :user

  validates :smoke_date, uniqueness: { scope: :user_id, message: "既に記録しています"}
end
