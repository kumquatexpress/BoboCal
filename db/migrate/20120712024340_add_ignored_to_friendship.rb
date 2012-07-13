class AddIgnoredToFriendship < ActiveRecord::Migration
  def change
    add_column :friendships, :ignored, :boolean
  end
end
