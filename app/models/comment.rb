class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post
  before_save :set_is_accepted, :if => :new_record?
  scope :accepted, -> { where(is_accepted: true) }

  private

  def set_is_accepted
    self.is_accepted = user.is_admin?
  end
end
