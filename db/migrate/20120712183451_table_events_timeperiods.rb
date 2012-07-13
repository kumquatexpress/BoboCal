class TableEventsTimeperiods < ActiveRecord::Migration
  def change
    create_table :events_timeperiods, :id => false do |t|
      t.integer :timeperiod_id
      t.integer :event_id
    end
  end
end
