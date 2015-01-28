class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.string :doc_id
      t.text :file_location
      t.text :doc_type
      t.text :resource_locator
      t.text :resource_data
      t.text :resource_data_type
      t.text :keys
      t.text :tos
      t.text :revision
      t.text :payload_schema_locator
      t.text :payload_placement
      t.text :payload_schema
      t.text :node_timestamp
      t.text :digital_signature
      t.text :create_timestamp
      t.text :doc_version
      t.text :identity
      t.text :full_record
      t.timestamps
    end
  end
end
