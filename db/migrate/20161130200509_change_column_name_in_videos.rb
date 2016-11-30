class ChangeColumnNameInVideos < ActiveRecord::Migration
  def change
    rename_column :videos, :small_title_url, :small_cover_url
  end
end
