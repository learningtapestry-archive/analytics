class ChangeRawMessageHtmlText < ActiveRecord::Migration
  def up
    change_table :raw_messages do |t|
      t.change :html, :text
    end
  end
 
  def down
    change_table :raw_messages do |t|
      t.change :html, :string
    end
  end
end
