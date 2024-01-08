class CreateSmokeRecords < ActiveRecord::Migration[7.0]
  def change
    create_table :smoke_records do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :smoked
      t.date :smoke_date

      t.timestamps
    end
  end
end
