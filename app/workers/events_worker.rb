require 'iron_worker'

class EventsWorker < IronWorker::Base
  
  attr_accessor :userid
  
  def run
    user = User.find(userid)
    user.find_events
  end
end
