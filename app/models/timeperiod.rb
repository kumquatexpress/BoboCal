class Timeperiod < ActiveRecord::Base
  attr_accessible :time, :user_id
  
  belongs_to :user
  has_and_belongs_to_many :event
end
