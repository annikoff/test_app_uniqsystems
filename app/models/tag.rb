class Tag < ApplicationRecord
  has_many :taggings, :dependent => :destroy
  has_many :posts, through: :taggings, source: :taggable, source_type: Post

  def self.destroy_not_associated_tags
    Tag.includes(:taggings).where(taggings: { taggable_id: nil }).destroy_all
  end
end
