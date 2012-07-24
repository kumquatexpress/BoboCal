class Event < ActiveRecord::Base
  validate :title, :presence => true
  
  has_event_calendar

  has_and_belongs_to_many :calendars
  has_and_belongs_to_many :posts
  has_and_belongs_to_many :timeperiods
    
  belongs_to :user
  
  has_and_belongs_to_many :invited_users, :class_name => "User"
  
  attr_accessible :id, :calendar_ids, :end_at, :start_at, :title, :user_id, :invited_users,
  :startDate, :startHour, :endDate, :endHour, :google_id
  
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
  
  def self.save_to_google_calendar(event_id)    
    oauth_yaml = YAML.load_file('.google-api.yaml')
    client = Google::APIClient.new
    client.authorization.client_id = oauth_yaml["client_id"]
    client.authorization.client_secret = oauth_yaml["client_secret"]
    client.authorization.scope = oauth_yaml["scope"]
    client.authorization.refresh_token = oauth_yaml["refresh_token"]
    client.authorization.access_token = oauth_yaml["access_token"]
    
    if client.authorization.refresh_token && client.authorization.expired?
      client.authorization.fetch_access_token!
    end
    
    event = Event.find(event_id)

    #form the attendees array to invite users to gcal event
    attendees = Array.new
    event.invited_users.each do |user|
      attendees.push("email" => "#{user.email}")
    end
    attendees.push("email" => "#{User.find(event.user_id).email}")
    logger.info attendees    
    
    #form the body of the request to post to google
    event_string = {
    'summary' => event.title,
    'location' => "asdf",
    'start' => {
      'dateTime' => event.start_at
      },
    'end' => {
      'dateTime' => event.end_at
      },
    'attendees' => attendees
    }
    
    service = client.discovered_api('calendar', 'v3')
    res = client.execute(:api_method => service.events.insert,
                    :parameters => {'calendarId' => '{primary}'},
                    :body => JSON.dump(event_string),
                    :headers => {'Content-Type' => 'application/json'})
                    
    logger.info JSON.dump(event_string)
    logger.info res.data.id
    logger.info "123123123"
  end
    
  
end