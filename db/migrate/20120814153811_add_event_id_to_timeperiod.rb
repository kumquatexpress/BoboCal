class AddEventIdToTimeperiod < ActiveRecord::Migration
  def change
    add_column :timeperiods, :event_id, :integer
  end
end
