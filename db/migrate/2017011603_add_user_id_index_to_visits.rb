class AddUserIdIndexToVisits < ActiveRecord::Migration
  def change
    add_index :visits, :user_id
  end
end
