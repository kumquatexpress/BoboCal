class AddIdsToCalendarEvent < ActiveRecord::Migration
  def up
    add_column :events, :calendar_id, :integer
    add_column :calendars, :event_id, :integer
  end
end
