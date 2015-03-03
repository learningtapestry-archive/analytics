class CreateRawDocuments < ActiveRecord::Migration
  def change
    create_table :raw_documents do |t|
      t.string  :doc_id
      t.boolean :active
      t.string  :doc_type
      t.string  :doc_version
      t.text    :identity
      t.text    :keys
      t.string  :payload_placement
      t.text    :payload_schema
      t.json    :resource_data_json
      t.xml     :resource_data_xml
      t.text    :resource_data_string
      t.string  :resource_data_type
      t.string  :resource_locator 
      t.text    :raw_data

      t.timestamps null: false
    end

    add_index :raw_documents, :doc_id, :unique => true

    create_table :raw_document_logs do |t|
      t.string  :action
      t.date    :newest_import_date

      t.timestamps null: false
    end
  end
end