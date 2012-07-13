class AddEventIdToPost < ActiveRecord::Migration
  def change
    add_column :posts, :event_id, :integer
    add_column :events, :post_id, :integer
  end
end
