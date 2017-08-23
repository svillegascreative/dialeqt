class Tag < ApplicationRecord
  has_many :taggings
  has_many :words, -> { distinct }, through: :taggings

  validates_uniqueness_of :name

  acts_as_url :name,
    url_attribute: :slug,
    sync_url: true,
    blacklist: %W{new edit},
    blacklist_policy: :blacklist_policy

  def self.find(input)
    find_by_slug(input)
  end

  def to_param
    slug
  end

  def blacklist_policy
    Proc.new {|w| "tag-#{w}"}
  end
end
