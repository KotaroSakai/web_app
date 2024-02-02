class SendSet < ApplicationRecord
  belongs_to :user

  enum send_active: {OFF: false, ON: true}

  private

end
