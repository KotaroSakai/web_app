class CreateSendSets < ActiveRecord::Migration[7.0]
  def change
    create_table :send_sets do |t|
      t.references :user, null: false, foreign_key: true
      t.time :set_time
      t.boolean :send_active

      t.timestamps
    end
  end
end
