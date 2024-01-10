class SendSet < ApplicationRecord
  belongs_to :user

  enum send_active: {off: false, on: true}

  private

end
