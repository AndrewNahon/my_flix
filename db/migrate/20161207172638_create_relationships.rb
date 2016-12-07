class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.integer :follower_id, :followed_user_id
      t.timestamps
    end
  end
end
