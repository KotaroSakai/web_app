class CreateTobaccos < ActiveRecord::Migration[7.0]
  def change
    create_table :tobaccos do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :price
      t.integer :baseline_cigarette

      t.timestamps
    end
  end
end
