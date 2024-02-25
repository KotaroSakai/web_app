class AddUniqueIndexToUserPartners < ActiveRecord::Migration[7.0]
  def change
    #add_index :user_partners, [:follower_id, :followed_id], unique: true
  end
end
