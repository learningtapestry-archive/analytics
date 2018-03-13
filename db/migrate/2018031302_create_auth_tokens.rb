# frozen_string_literal: true

class CreateAuthTokens < ActiveRecord::Migration
  def change
    create_table :auth_tokens, force: true do |t|
      t.integer :dashboard_id
      t.string :value, null: false, uniqueness: true
      t.timestamps null: false
    end

    add_foreign_key :auth_tokens, :dashboards, on_delete: :cascade
  end
end
