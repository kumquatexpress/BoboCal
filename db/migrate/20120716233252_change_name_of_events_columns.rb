class ChangeNameOfEventsColumns < ActiveRecord::Migration
  def change 
    rename_column :events, :endTime, :end_at
    rename_column :events, :startTime, :start_at
  end
end
