class Print < ActiveRecord::Base
  belongs_to :user
  scope :for_user, lambda { |user_id| {:conditions => ["user_id = ?", user_id]}} 
  has_attached_file :image,
    :convert_options => { :quality =>  4 },
    :styles => { :small_thumb => [ "50x50", :jpg ],
      :medium_thumb => [ "176x120", :jpg ],
      :large_thumb => [ "370x370", :jpg ],
      :detail_preview => [ "450x338", :jpg ] }
  #:url => "tmp/:attachment/:id/:style/:filename",
  #:path => ":rails_root/tmp/:attachment/:id/:style/:filename"
  #:default_url => "tmp/images/:id/:style.:extension"
  
  validates_attachment_size :image, :less_than => 4.megabytes, :message => "file size should be less than 4MB"

  validates_attachment_content_type :image, :content_type => ['image/jpg', 'image/pjpeg', 'image/jpeg', 'image/png','image/x-png','image/gif'], :message=> "Invalid image, image format should be jpeg/ jpg/ png/ gif"
end
