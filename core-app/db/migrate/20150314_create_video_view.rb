class CreateVideoView < ActiveRecord::Migration
  def change
    create_table :videos, force: true do |t|
      t.text :service_id
      t.text :external_id
      t.text :url
      t.time :video_length
      t.text :title
      t.text :views
      t.text :likes
      t.text :dislikes
      t.text :publisher
      t.text :category
      t.text :license
      t.text :published_on

      t.timestamps                    null: true
    end

    create_table :video_views, force: true do |t|
      t.datetime :time_started
      t.datetime :time_ended
      t.integer :paused_count

      t.belongs_to :user
      t.belongs_to :video
      t.belongs_to :page

      t.timestamps                    null: true
    end
  end
end