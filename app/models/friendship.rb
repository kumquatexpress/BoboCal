class Friendship < ActiveRecord::Base
  belongs_to :user
  belongs_to :friend, :class_name => 
  "User", :foreign_key => "friend_id"
  attr_accessible :approved, :friend_id, :user_id

  def ignore
    self.ignored = true
    self.save
  end

  def approve
    self.approved = true
    self.save
  end
  
  def make_new(first_user, second_user, approve)
    if Friendship.where(:user_id => first_user.id, :friend_id => second_user.id) == []
        friendship = self
        friendship.user_id = first_user.id
        friendship.friend_id = second_user.id
        friendship.approved = approve
        friendship.ignored = false
        friendship.save
    end
  end

end
