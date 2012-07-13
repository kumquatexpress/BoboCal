class Calendar < ActiveRecord::Base
  attr_accessible :title, :event_ids
  has_and_belongs_to_many :event
  belongs_to :user
  
  def owned_by_user?(user)
    return user.calendars.where(:id => self.id) == []
  end
  
end
