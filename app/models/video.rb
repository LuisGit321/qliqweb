class Video < ActiveRecord::Base
  
  scope :for_user, lambda { |user_id| {:conditions => ["user_id = ?", user_id]}} 
  belongs_to :user
  has_attached_file :original
  #, :path => "tmp/videos/:original/:id.:extension",

end
