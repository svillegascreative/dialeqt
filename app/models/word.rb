class Word < ApplicationRecord
  # include Searchable
  include WilsonScorer

  has_many :definitions, dependent: :restrict_with_error
  belongs_to :user

  validates_uniqueness_of :name

  acts_as_votable

  acts_as_url :name,
    url_attribute: :slug,
    sync_url: true,
    blacklist: %W{new edit},
    blacklist_policy: :blacklist_policy

  def self.find(input)
    find_by_slug(input)
  end

  def self.search(query, columns)
    where(
      columns.map{|c| "#{c} ilike :search" }.join(' OR '),
      search: "%#{query}%"
    )
  end

  def to_param
    slug
  end

  def blacklist_policy
    Proc.new {|w| "word-#{w}"}
  end

  def has_votes?
    true if cached_votes_total > 0
  end

  def has_votes_or_definitions?
    true if has_votes? || self.definitions
  end

  def cannot_be_edited?
    true if has_votes_or_definitions?
  end

  def cannot_be_destroyed?
    true if has_votes_or_definitions?
  end
end
