class AddCalendarsUsersTable < ActiveRecord::Migration
  def up
    create_table :calendars_users, :id => false do |t|
      t.integer :calendar_id
      t.integer :user_id
    end
  end

  def down
    drop_table :calendars_users
  end
  
end
