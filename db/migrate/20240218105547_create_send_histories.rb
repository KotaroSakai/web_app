class CreateSendHistories < ActiveRecord::Migration[7.0]
  def change
    create_table :send_histories do |t|
      t.references :user, null: false, foreign_key: true
      t.datetime :send_at

      t.timestamps
    end
  end
end
