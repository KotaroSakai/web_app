class AddSendTypeIdToSendHistories < ActiveRecord::Migration[7.0]
  def change
    add_column :send_histories, :send_type_id, :integer
    add_foreign_key :send_histories, :send_types, column: :send_type_id
  end
end
