class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :username, :login
  attr_accessor :login
  cattr_accessor :current_user

  
  has_many :friendships, :dependent => :destroy
  has_many :friends, :through => :friendships, :uniq => true

  has_many :followerships, :class_name => 'Friendship', :foreign_key => :friend_id, :dependent => :destroy
  has_many :followers, :through => :followerships, :source => :user, :uniq => true

  has_many :entries
  
  scope :username_search, lambda {|q|
    where 'username like :q ', :q => "%#{q}%"
  }
  # attr_accessible :title, :body

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    login = conditions.delete(:login)
    where(conditions).where(["lower(username) = :value OR lower(email) = :value",{:value => login.downcase}]).first
  end

  def timeline
    @entries = Entry.where(:user_id => (self.friends << self))
  end

  def follow?
    if self == current_user
      "self"
    elsif current_user.friends.exists?(self.id)
      "followed"
    else
      "not yet follow"
    end
  end

  def entries_count
    self.entries.count
  end

  def friends_count
    self.friends.count
  end

  def followers_count
    self.followers.count
  end
  
end
