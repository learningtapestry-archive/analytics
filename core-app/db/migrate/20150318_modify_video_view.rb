class ModifyVideoView < ActiveRecord::Migration
  def change
    add_column :video_views, :time_viewed, :interval
  end
end