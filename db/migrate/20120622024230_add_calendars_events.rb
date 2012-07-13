class AddCalendarsEvents < ActiveRecord::Migration
  def up
    create_table :calendars_events, :id => false do |t|
      t.integer :calendar_id
      t.integer :event_id
    end
  end

  def down
    drop_table :calendars_events
  end
end
