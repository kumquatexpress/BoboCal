class Event < ActiveRecord::Base
  validate :title, :presence => true

  has_and_belongs_to_many :calendar
  has_and_belongs_to_many :post
  has_and_belongs_to_many :timeperiod
  
  belongs_to :user
  
  has_and_belongs_to_many :invited_users, :class_name => "User", :foreign_key => "invited_id" 
  
  attr_accessible :id, :calendar_ids, :endTime, :startTime, :title, :user_id, :invited_users
  
  def fits?()
    cal = Calendar.find(self.calendar_ids)
    cal.each do |c|
      all_events =Event.find(c.event_ids)
      all_events.each do |event|
        if (self.startTime < event.startTime &&
          self.endTime < event.startTime) ||
          (self.startTime > event.endTime &&
          self.endTime > event.endTime)
        else
          return false
        end
      end
    end
    return true
  end
  
  def find_calendar(calendar_id)
    self.calendar_id = calendar_id
  end
  
  def in_calendar?(calendar)
    return !(calendar.event.where(:id => self.id) == [])
  end
  
end