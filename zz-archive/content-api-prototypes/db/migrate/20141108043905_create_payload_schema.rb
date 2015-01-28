class CreatePayloadSchema < ActiveRecord::Migration
  def change
    create_table :payload_schemas do |t|
      t.string :name
      t.timestamps
    end

    create_join_table :documents, :payload_schemas
  end
end
