class AddPageMsgsIndexToRawMessages < ActiveRecord::Migration
  def change
    add_index 'raw_messages',
      ['processed_at', 'verb', 'captured_at'],
      order: { captured_at: :desc },
      where: 'processed_at IS NULL'
  end
end
