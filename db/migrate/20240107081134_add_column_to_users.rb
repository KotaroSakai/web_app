class AddColumnToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :provider, :string
    add_column :users, :uid, :string

    remove_column :users, :user_line, :string
  end
end
