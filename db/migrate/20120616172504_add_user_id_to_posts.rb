class AddUserIdToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :userid, :string
  end
end
