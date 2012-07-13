class AddCalendarToEvents < ActiveRecord::Migration
  def change
    add_column :events, :calendar_id, :integer
    add_column :events, :user_id, :integer
  end
end
