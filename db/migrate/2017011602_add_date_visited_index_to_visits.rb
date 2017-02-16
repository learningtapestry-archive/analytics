class AddDateVisitedIndexToVisits < ActiveRecord::Migration
  def change
    add_index :visits, :date_visited
  end
end
