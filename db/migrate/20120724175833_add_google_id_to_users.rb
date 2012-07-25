class AddGoogleIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :google_id, :string, :limit => 64
  end
end
