class CorrectColumnFriendEmailInInvitations < ActiveRecord::Migration
  def change
    rename_column :invitations, :frined_email, :friend_email
  end
end
