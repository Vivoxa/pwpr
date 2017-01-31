class RemoveMembershipIdFromBusinesses < ActiveRecord::Migration
  def change
    remove_column :businesses, :membership_id, :integer
  end
end
