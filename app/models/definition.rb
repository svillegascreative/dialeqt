class Definition < ApplicationRecord
  # include Searchable
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
end
