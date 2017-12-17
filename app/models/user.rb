class User < ActiveRecord::Base
  attr_accessor :password, :api_post_unrestricted, :my_images
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  VALID_NAME_REGEX = /\A[a-zA-Z]+\Z/
  belongs_to :role
  has_many :user_images, :dependent => :destroy
  validates_confirmation_of :password
  validates_presence_of :password, unless: :api_post_unrestricted
  validates_presence_of :email
  validates_uniqueness_of :email
  validates :first_name, format: { with: VALID_NAME_REGEX }, :allow_blank => true
  validates :last_name, format: { with: VALID_NAME_REGEX }, :allow_blank => true
  validates :email, format: { with: VALID_EMAIL_REGEX }
  before_save { |user| user.email = user.email.downcase }
  before_save { |user| user.first_name = user.first_name.downcase unless user.first_name.nil? }
  before_save { |user| user.last_name = user.last_name.downcase unless user.last_name.nil? }
  before_save :encrypt_password
  
  def full_name
    if first_name.present? && last_name.present?
      "#{first_name.capitalize} #{last_name.capitalize}"
    elsif last_name.present?
      "#{last_name.capitalize}"
    end
  end
  
  def identity
    full_name.present? ? full_name : email
  end
  
  def encrypt_password
    if password.present?
      self.password_salt = SCrypt::Engine.generate_salt
      self.password_hash = SCrypt::Engine.hash_secret(password, password_salt)
    end
  end
  
  def self.authenticate(email, password)
    u = find_by_email(email.downcase)
    return u if u && u.password_hash == SCrypt::Engine.hash_secret(password, u.password_salt)
  end
end
