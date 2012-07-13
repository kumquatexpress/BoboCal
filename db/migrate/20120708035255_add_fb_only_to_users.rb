class AddFbOnlyToUsers < ActiveRecord::Migration
  def change
    add_column :users, :fbonly, :boolean
  end
end
