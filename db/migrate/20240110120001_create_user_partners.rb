class CreateUserPartners < ActiveRecord::Migration[7.0]
  def change
    create_table :user_partners do |t|
      t.references :follower, null: false, foreign_key: { to_table: :users }
      t.references :followed, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end

    add_index :user_partners, [:follower_id, :followed_id], unique: true
  end
end
