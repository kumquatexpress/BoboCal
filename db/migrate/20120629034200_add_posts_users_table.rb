class AddPostsUsersTable < ActiveRecord::Migration
  def up
    create_table :posts_users, :id => false do |t|
      t.integer :post_id
      t.integer :user_id
    end
  end

  def down
    drop_table :posts_users
  end
end
