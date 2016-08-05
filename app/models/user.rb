class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :validatable
  validates_presence_of :name
  has_many :comments
  before_create :set_is_admin

  def set_is_admin
    self.is_admin = self.class.all.size.zero?
  end
end
