class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.string :friend_name, :frined_email, :token
      t.text :message
      t.timestamps
    end
  end
end
