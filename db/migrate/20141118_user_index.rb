class UserIndex < ActiveRecord::Migration
  def up
    remove_index :users, :username
    # index prevents duplicates
    add_index :users, [:username, :organization_id], :unique => true
    # create a partial index on username where org_id is null
    # this prevents duplicate usernames from being added when org_id is null
    add_index :users, :username, :unique => true, where: "organization_id IS NULL"
    add_column :raw_messages, :organization_id, :integer
  end
  
  def down
    remove_index :users, [:username, :organization_id]
    remove_index :users, :username
    add_index :users, :username, :unique => true
    remove_column :raw_messages, :organization_id
  end
end