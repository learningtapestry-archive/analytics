class AddOrgApiKeyIndexToOrganizations < ActiveRecord::Migration
  def change
    add_index :organizations, :org_api_key
  end
end
