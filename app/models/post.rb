class Post < ActiveRecord::Base
  attr_accessible :content, :title

  belongs_to :board, :counter_cache => true
  belongs_to :user

  scope :recent, :order => "updated_at DESC"
end
