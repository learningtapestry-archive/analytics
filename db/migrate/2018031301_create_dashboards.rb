# frozen_string_literal: true

class CreateDashboards < ActiveRecord::Migration
  def change
    create_table :dashboards, force: true do |t|
      t.string :name, null: false, uniqueness: true
      t.timestamps null: false
    end
  end
end
