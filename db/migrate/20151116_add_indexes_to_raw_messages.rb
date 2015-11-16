class AddIndexesToRawMessages < ActiveRecord::Migration
  def change
    add_index :raw_messages, :verb
    add_index :raw_messages, :url
    add_index :raw_messages, :username
    add_index :raw_messages, :heartbeat_id
    add_index :raw_messages, :captured_at, order: {captured_at: :desc}
  end
end