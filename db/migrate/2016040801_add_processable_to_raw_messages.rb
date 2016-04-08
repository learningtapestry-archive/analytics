class AddProcessableToRawMessages < ActiveRecord::Migration
  def change
    add_column :raw_messages, :processable, :boolean
  end
end
