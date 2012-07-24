class Entry < ActiveRecord::Base
  attr_accessible :avatar, :user_id
  mount_uploader :avatar, AvatarUploader
  belongs_to :user

  default_scope :order => "id DESC"

end
