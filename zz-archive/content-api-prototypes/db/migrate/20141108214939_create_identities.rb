class CreateIdentities < ActiveRecord::Migration
  def change
    create_table :identities do |t|
      t.text :submitter
      t.text :submitter_type
      t.text :curator
      t.text :signer
      t.text :owner
      t.text :hash
      t.timestamps
    end

    change_table(:documents) do |t|
      t.belongs_to :identity
    end

  end
end
