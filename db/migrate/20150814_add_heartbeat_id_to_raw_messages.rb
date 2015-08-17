class AddHeartbeatIdToRawMessages < ActiveRecord::Migration
  def change
    add_column :raw_messages, :heartbeat_id, :string
  end
end