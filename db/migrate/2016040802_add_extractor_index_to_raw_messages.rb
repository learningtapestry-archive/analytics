class AddExtractorIndexToRawMessages < ActiveRecord::Migration
  def change
    remove_index 'raw_messages', ['processed_at', 'verb', 'captured_at']

    add_index 'raw_messages', :verb,
      name: 'idx_raw_messages_extractor',
      where: 'processed_at IS NULL and processable IS NULL'
  end
end
