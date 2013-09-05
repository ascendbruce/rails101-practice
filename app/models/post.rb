class Post < ActiveRecord::Base
  attr_accessible :content, :title, :image

  belongs_to :board, :counter_cache => true
  belongs_to :user

  has_attached_file :image, :styles => { :show => "640x480>", :thumb => "100x100#" }

  scope :recent, :order => "updated_at DESC"
end
