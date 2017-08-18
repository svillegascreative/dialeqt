class Tag < ApplicationRecord
  has_many :taggings
  has_many :words, through: :taggings

  validates_uniqueness_of :name
end
