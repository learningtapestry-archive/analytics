class AddOrganizationIdIndexToUsers < ActiveRecord::Migration
  def change
    add_index :users, :organization_id
  end
end
