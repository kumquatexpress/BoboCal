class AddCalendarAndPostToUser < ActiveRecord::Migration
  def change
    add_column :users, :calendar_id, :integer
    add_column :users, :event_id, :integer
    add_column :users, :post_id, :integer
  end
end
