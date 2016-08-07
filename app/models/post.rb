class Post < ApplicationRecord
  belongs_to :category
  has_many :comments, :dependent => :destroy
  include Taggable
  validates_presence_of :title, :body, :category
end
