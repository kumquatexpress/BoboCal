class AddStartAtEndAtToTimeperiods < ActiveRecord::Migration
  def change
    add_column :timeperiods, :start_at, :datetime
    add_column :timeperiods, :end_at, :datetime
  end
end
