class ChangeRawStatementDateTimes < ActiveRecord::Migration
  def up
    change_table :raw_messages do |t|
      t.change :date_captured, :datetime
      t.change :date_created, :datetime
      t.change :date_updated, :datetime
    end
  end
 
  def down
    change_table :raw_messages do |t|
      t.change :date_captured, :date
      t.change :date_created, :date
      t.change :date_updated, :date
    end
  end
end
