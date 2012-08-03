require 'iron_worker'

class FriendsWorker < IronWorker::Base

  require 'active_record'
  merge "../models/user.rb"
  
  
  attr_accessor :userid
  
  def run
    user = User.find(userid)
    user.find_friends
  end
  
end
