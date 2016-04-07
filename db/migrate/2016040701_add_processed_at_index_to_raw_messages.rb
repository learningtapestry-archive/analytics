class AddProcessedAtIndexToRawMessages < ActiveRecord::Migration
  def change
    add_index :raw_messages, :processed_at
  end
end
