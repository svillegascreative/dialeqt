class Definition < ApplicationRecord
  include Searchable
  include Votable
  include Flaggable
  include WilsonScorer
  include NiceDateTimer

  belongs_to :word
  belongs_to :user

  validates :details, presence: true

  def has_votes?
    true if cached_votes_total > 0
  end

  def cannot_be_edited?
    true if has_votes?
  end

  def cannot_be_destroyed?
    true if has_votes?
  end
end
