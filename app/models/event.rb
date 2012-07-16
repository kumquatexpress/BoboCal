class Event < ActiveRecord::Base
  validate :title, :presence => true
  
  has_event_calendar

  has_and_belongs_to_many :calendar
  has_and_belongs_to_many :post
  has_and_belongs_to_many :timeperiod
  
  belongs_to :user
  
  has_and_belongs_to_many :invited_users, :class_name => "User"
  
  attr_accessible :id, :calendar_ids, :endTime, :startTime, :title, :user_id, :invited_users,
  :startDate, :startHour, :endDate, :endHour
  
  attr_accessor :startDate, :startHour, :endDate, :endHour
  
  # add some callbacks
  after_initialize :get_datetimes # convert db format to accessors
  before_validation :set_datetimes # convert accessors back to db format

  def get_datetimes
    self.start_at ||= Time.now
    self.end_at ||= Time.now  # if the published_at time is not set, set it to now

    self.startDate ||= self.start_at.to_date.to_s(:db) # extract the date is yyyy-mm-dd format
    self.startHour ||= "#{'%02d' % self.start_at.hour}:#{'%02d' % self.start_at.min}" # extract the time
    
    self.endDate ||= self.end_at.to_date.to_s(:db) # extract the date is yyyy-mm-dd format
    self.endHour ||= "#{'%02d' % self.end_at.hour}:#{'%02d' % self.end_at.min}" # extract the time
  end

  def set_datetimes
    self.start_at = "#{self.startDate} #{self.startHour}:00" # convert the two fields back to db
    self.end_at = "#{self.endDate} #{self.endHour}:00"
  end  

  #methods for adding invited users
  
  def self.add_invited_user(event_id, user_id)
    event = Event.find(event_id)
    user = User.find(user_id)
    unless event.invited_users.include?(user)
      event.invited_users.push(user)
      event.save
    end      
  end  
  
  def self.delete_invited_user(event_id, user_id)
    event = Event.find(event_id)
    user = User.find(user_id)
    event.invited_users.delete(user)
    event.save 
  end
  
  def find_calendar(calendar_id)
    self.calendar_id = calendar_id
  end
  
  def in_calendar?(calendar)
    return !(calendar.event.where(:id => self.id) == [])
  end
  
end