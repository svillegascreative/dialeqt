class Word < ApplicationRecord
  include Searchable
  include Votable
  include WilsonScorer
  include Flaggable
  include NiceDateTimer

  has_many :definitions, dependent: :restrict_with_error
  has_many :taggings
  has_many :tags, -> { distinct }, through: :taggings
  accepts_nested_attributes_for :tags, allow_destroy: true, reject_if: :all_blank
  belongs_to :user

  validates_uniqueness_of :name

  acts_as_url :name,
    url_attribute: :slug,
    sync_url: true,
    blacklist: %W{new edit},
    blacklist_policy: :blacklist_policy

  def self.find(input)
    find_by_slug(input)
  end

  def self.random
    offset(rand(Word.count)).first
  end

  def to_param
    slug
  end

  def has_votes?
    true if cached_votes_total > 0
  end

  def has_definitions?
    true if self.definitions.size > 0
  end

  def has_votes_or_definitions?
    true if self.has_votes? || self.has_definitions?
  end

private

  def blacklist_policy
    Proc.new {|w| "word-#{w}"}
  end

end
