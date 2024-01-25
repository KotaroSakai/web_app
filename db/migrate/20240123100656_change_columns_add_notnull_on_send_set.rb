class ChangeColumnsAddNotnullOnSendSet < ActiveRecord::Migration[7.0]
  def change
    change_column :send_sets, :send_active, :boolean, null: false
  end
end
