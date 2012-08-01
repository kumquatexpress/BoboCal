class AddAdminToEventsUsers < ActiveRecord::Migration
  def change
    add_column :events_users, :admin_user, :boolean, :default => false
    change_column_default(:events, :location, "My Crib")
  end
end
