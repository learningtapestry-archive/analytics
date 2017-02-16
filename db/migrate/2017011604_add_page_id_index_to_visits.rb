class AddPageIdIndexToVisits < ActiveRecord::Migration
  def change
    add_index :visits, :page_id
  end
end
