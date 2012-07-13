class Post < ActiveRecord::Base
  validates :title, :presence => true
  validates :content, :presence => true
  attr_accessible :content, :title, :userid
  has_and_belongs_to_many :event
  belongs_to :user
end
