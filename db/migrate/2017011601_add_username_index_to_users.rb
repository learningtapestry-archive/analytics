class AddUsernameIndexToUsers < ActiveRecord::Migration
  def change
    add_index :users, :username, name: 'idx_users_username_any'
  end
end
