class AddDefaultToEventTitle < ActiveRecord::Migration
  def change
    change_column_default(:events, :title, 'My New Event')
  end
end
