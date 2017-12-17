class Role < ActiveRecord::Base
  has_many :users, :dependent => :restrict_with_error
  validates_uniqueness_of :role
  validates_presence_of :role
end
