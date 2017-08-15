class Definition < ApplicationRecord
  # include Searchable
  include WilsonScorer

  belongs_to :word
  belongs_to :user

  validates :details, presence: true

  acts_as_votable

  def self.search(query, columns)
    where(
      columns.map{|c| "#{c} ilike :search" }.join(' OR '),
      search: "%#{query}%"
    )
  end

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
