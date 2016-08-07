class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :validatable
  validates_presence_of :name
  validates_uniqueness_of :name, :email
  has_many :comments
  before_create :set_is_admin
  after_create :welcome_message

  def set_is_admin
    self.is_admin = self.class.all.size.zero?
  end

  private

  def welcome_message
    UserMailer.welcome_message(self).deliver
  end
end
