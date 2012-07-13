class AddTableEventsUsers < ActiveRecord::Migration
  def change
    create_table :events_users, :id => false do |t|
      t.integer :invited_id
      t.integer :user_id
    end
  end
end
