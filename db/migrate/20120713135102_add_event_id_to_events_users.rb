class AddEventIdToEventsUsers < ActiveRecord::Migration
  def change
    rename_column :events_users, :invited_id, :event_id
  end
end
