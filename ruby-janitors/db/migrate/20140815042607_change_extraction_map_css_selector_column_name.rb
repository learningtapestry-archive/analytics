class ChangeExtractionMapCssSelectorColumnName < ActiveRecord::Migration
def self.up
    rename_column :extraction_maps, :css_selector, :xpath_selector
  end

  def self.down
    rename_column :extraction_maps, :xpath_selector, :css_selector
  end
end
