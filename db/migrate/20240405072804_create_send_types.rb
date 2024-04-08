class CreateSendTypes < ActiveRecord::Migration[7.0]
  def change
    create_table :send_types do |t|
      t.string :send_class, null: false
      
      t.timestamps
    end
  end
end
