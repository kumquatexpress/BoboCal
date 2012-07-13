class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.datetime :startTime
      t.datetime :endTime

      t.timestamps
    end
  end
end
