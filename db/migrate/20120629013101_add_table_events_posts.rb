class AddTableEventsPosts < ActiveRecord::Migration
  def up
    create_table :events_posts, :id => false do |t|
      t.integer :post_id
      t.integer :event_id
    end
  end

  def down
    drop_table :events_posts
  end
  
end
