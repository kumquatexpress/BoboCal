class User < ActiveRecord::Base
  #validates_format_of :zipcode, :with => /^\d{5}(-\d{4})?$/
  devise :omniauthable
  require 'open-uri'
  require 'json'
  
  validate :first_name, :presence => true
  validate :last_name, :presence => true

  has_many :friendships
  has_many :inverse_friendships, :class_name => "Friendship", :foreign_key => "friend_id"
 
  has_many :direct_friends, :through => :friendships, :conditions => "approved = true", :source => :friend
  has_many :inverse_friends, :through => :inverse_friendships, :conditions => "approved = true", :source => :user
  
  has_many :pending_friends, :through => :friendships, :conditions => "approved = false and ignored = false", :foreign_key => "user_id", :source => :friend
  has_many :requested_friends, :through => :inverse_friendships, :foreign_key => "friend_id", :conditions => "approved = false and ignored = false", :source => :user  
  
  has_many :calendars
  
  has_many :events
  has_and_belongs_to_many :invited_events, :class_name => "Event"
  
  has_many :posts
  has_many :timeperiods
 
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :token_authenticatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :zipcode, :city, :state,
  :first_name, :last_name, :provider, :uid, :image_url, :fbonly, :name
  # attr_accessible :title, :body
  
  def set_default_picture
    user = self
      unless user.image_url
        user.image_url = 'default_fb_pic.jpg'
      end
      user.save
  end  
  
  def find_friends
    user = self
    token = user.fb_token
    id = user.uid
    
    request_url = 'https://graph.facebook.com/' + id +'/friends?access_token='+ token
    logger.info request_url
    
    body = open(request_url).read
    parsed_json = JSON(body)
    
    parsed_json["data"].each do |data| 
      uid = data["id"]
      
      tempuser = User.where(:uid => uid.to_s()).first
      unless tempuser
        image_url = "http://graph.facebook.com/"+uid+"/picture?type=large"
        logger.info "FRIENDIMAGE" + image_url
        
        name = data["name"]
        tempuser = User.new(:name => name,
                       :uid => uid,
                       :email=> name + "@facebook.com",
                       :image_url => image_url,
                       :password=>Devise.friendly_token[0,20],
                       :fbonly => true
                       )
        tempuser.save
        tempuser.set_default_picture
      end
      
      friendship = Friendship.new
      friendship.make_new(self, tempuser, true)
    end
  end
  
  def find_events
    user = self
    request_url = 'https://www.googleapis.com/calendar/v3/users/me/calendarList?access_token='+user.token
    body = open(request_url).read
    parsedjson = JSON(body)
    
    calendar_types = Array.new
    
    parsedjson["items"].each do |item|
      calendar_types.push(item["id"])
      logger.info id
    end
    
    calendar_types.each do |cal|
      request_url = 'https://www.googleapis.com/calendar/v3/calendars/'+cal+'/events?access_token='+user.token
      logger.info request_url
      
      body = open(request_url).read      
      parsedjson = JSON(body)
      
      if parsedjson["items"]
        parsedjson["items"].each do |event|          
          unless Event.where(:google_id => event["id"]).first
            if event["start"] && event["end"] && event["start"]["dateTime"] && event["end"]["dateTime"]
              unless Time.parse(event["end"]["dateTime"].to_s) < Time.now
                new_event = Event.new(:start_at => event["start"]["dateTime"],
                          :title => event["summary"],
                          :end_at => event["end"]["dateTime"],
                          :google_id => event["id"])
                new_event.user_id = user.id
                new_event.save
              end
            end
          end
        end
      end
    end
  end
  
  def friends
    direct_friends | inverse_friends
  end
  
  def is_friends?(user)
    return self.friends.include?(user)
  end
  
  def is_pending_friends?(user)
    return self.pending_friends.include?(user) || self.requested_friends.include?(user)
  end
  
  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end
  
  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:uid => auth.uid).first
    email = auth.info.email    
    unless email
        email = auth.info.nickname + '@facebook.com'
    end
    
    unless user
      image_url = "http://graph.facebook.com/"+auth.uid+"/picture?type=large"
      user = User.create(:name => auth.info.name,
                           :provider => auth.provider,
                           :uid => auth.uid,
                           :email=> email,
                           :image_url => image_url,
                           :password=>Devise.friendly_token[0,20]
                           )
    end
    
    if user.fbonly = true
      user.name = auth.info.name
      user.email = email
      user.password = Devise.friendly_token[0,20]
      user.save
    end
    
    user.fb_token = auth.credentials.token
    user.save
    
    user.delay.find_friends
    user
  end
  
  def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
    data = access_token.info
    tokens = access_token.credentials
    logger.info access_token
    
    email = data.email  
    
    user = User.where(:email => email).first
    unless user
        user = User.create(:name => data.name,
                     :provider => 'google',
                     :email=> email,
                     :password=>Devise.friendly_token[0,20]
                     )
        user.set_default_picture
    end
    user.refresh_token = tokens.refresh_token
    user.token = tokens.token
    user.save
    
    user.find_events
    
    user
  end
  
  def has_requests?
    if self.requested_friends.count == 0
      return false
    end
    return true
  end 

  def self.search(name)
    if name
      find(:all, :order => ['case when lower(name) LIKE '+ "'" +name+ '%' + "' " + 'then 1 else 0 end DESC,' +
        'case when lower(email) LIKE '+ "'" +name+ '%' + "' " + 'then 1 else 0 end DESC'],
      :conditions => ['lower(name) LIKE ? OR lower(email) LIKE ?', "%#{name}%", "%#{name}%"])
    else
      find(:all)
    end
  end

  def self.search_friends(name)
    if name
      
    end
  end

end
