class CreateTimeperiods < ActiveRecord::Migration
  def change
    create_table :timeperiods do |t|
      t.datetime :time
      t.integer :user_id

      t.timestamps
    end
  end
end
