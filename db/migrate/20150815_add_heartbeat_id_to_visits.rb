class AddHeartbeatIdToVisits < ActiveRecord::Migration
  def change
    add_column :visits, :heartbeat_id, :string
    add_index :visits, [:page_id, :heartbeat_id], unique: true
  end
end