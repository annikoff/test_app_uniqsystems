class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post
  before_save :set_is_accepted, :if => :new_record?
  scope :accepted, -> { where(is_accepted: true) }
  validates_presence_of :post

  private

  def set_is_accepted
    self.is_accepted = user.present? && user.is_admin?
  end
end
