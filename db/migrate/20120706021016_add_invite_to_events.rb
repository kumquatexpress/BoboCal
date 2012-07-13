class AddInviteToEvents < ActiveRecord::Migration
  def change
    add_column :events, :invited_ids, :integer
  end
end
