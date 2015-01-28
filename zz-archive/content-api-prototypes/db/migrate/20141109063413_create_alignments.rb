class CreateAlignments < ActiveRecord::Migration
  def change
    create_table :alignments do |t|
      t.text :framework
      t.text :name
      t.text :type
      t.text :description
      t.text :url
      t.text :hash

      t.timestamps
    end

    create_join_table :documents, :alignments, table_name: :documents_alignments
  end

end
