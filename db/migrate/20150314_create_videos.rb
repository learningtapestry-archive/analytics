class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos, force: true do |t|
      t.text 'service_id'
      t.text 'external_id'
      t.text 'url', null: false
      t.text 'title'
      t.text 'description'
      t.text 'publisher'
      t.text 'category'
      t.column 'video_length', :interval
      t.column 'views', :bigint
      t.float 'rating'
      t.column 'raters', :bigint
      t.datetime 'published_on'
      t.datetime 'updated_on'
      t.timestamps                    null: true
    end

    create_table :visualizations, force: true do |t|
      t.datetime 'date_started'
      t.datetime 'date_ended'
      t.datetime 'date_fragment_started'
      t.integer 'time_viewed', default: 0
      t.string 'session_id'

      t.belongs_to :user
      t.belongs_to :video
      t.belongs_to :page

      t.timestamps                    null: true
    end
  end
end
