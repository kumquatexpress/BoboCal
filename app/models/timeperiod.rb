class Timeperiod < ActiveRecord::Base
  attr_accessible :time, :user_id, :startDate, :startHour, :endDate, :endHour
  
  belongs_to :user
  belongs_to :event

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

end
