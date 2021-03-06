module Taggable
  extend ActiveSupport::Concern

  included do
    has_many :taggings, :as => :taggable
    has_many :tags, :through => :taggings
    after_save :destroy_not_associated_tags
    after_save :save_taggings
  end

  def tag_name=(tag_name)
    tag_name.strip!
    return if tag_name.blank?
    @taggings_to_save ||= []
    tag = Tag.find_or_create_by(name: tag_name)
    @taggings_to_save << self.taggings.find_or_initialize_by(tag_id: tag.id)
  end

  def tag_names=(tag_names)
    tag_names.each do |tag_name|
      self.tag_name=tag_name
    end
  end

  def tag_names
    tags.collect(&:name)
  end

  private

  def destroy_not_associated_tags
    Tag.destroy_not_associated_tags
  end

  def save_taggings
    return if @taggings_to_save.blank?
    @taggings_to_save.each(&:save)
  end
end
