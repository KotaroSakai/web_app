class AddDefaultToSendActiveInSendSets < ActiveRecord::Migration[7.0]
  def change
    change_column_default :send_sets, :send_active, from: nil, to: false
    change_column_default :send_sets, :set_time, from: nil, to: '09:00:00'
  end
end
