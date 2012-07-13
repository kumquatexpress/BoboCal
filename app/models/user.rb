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
  
  has_many :pending_friends, :through => :friendships, :conditions => "approved = false", :foreign_key => "user_id", :source => :user
  has_many :requested_friends, :class_name => "Friendship", :foreign_key => "friend_id", :conditions => "approved = false and ignored = false"
 
  has_many :calendars
  has_many :events
  has_many :posts
  has_many :timeperiod
 
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
      
      /#existing_friendship = Friendship.where(:user_id => self.id.to_s(), :friend_id => tempuser.id.to_s()).first
      inverse_existing_friendship = Friendship.where(:friend_id => self.id.to_s(), :user_id => tempuser.id.to_s()).first
      
      friend_id = tempuser.id
      
      unless existing_friendship || inverse_existing_friendship || tempuser.id == self.id
        friendship = Friendship.new(:user_id => self.id,
                                         :friend_id => friend_id,
                                         :approved => true)
        friendship.save
      end#/ 
    end
  end
  
  
  def friends
    direct_friends | inverse_friends
  end
  
  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end
  
  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    
    unless user
      email = auth.info.email
      image_url = "http://graph.facebook.com/"+auth.uid+"/picture?type=large"
      unless email
        email = auth.info.nickname + '@facebook.com'
      end
      user = User.create(:name => auth.info.name,
                           :provider => auth.provider,
                           :uid => auth.uid,
                           :email=> email,
                           :image_url => image_url,
                           :password=>Devise.friendly_token[0,20]
                           )
    end
    user.fb_token = auth.credentials.token
    user.save
    
    user.delay.find_friends
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
      find(:all, :order => ['case when lower(name) LIKE '+"'"+name+'%'+"' "'then 1 else 0 end DESC'],
      :conditions => ['lower(name) LIKE ?', "%#{name}%"])
    else
      find(:all)
    end
  end


end
