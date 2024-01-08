class AddUserLineToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :user_line, :string
  end
end
