class Word < ApplicationRecord
  # include Searchable
  has_many :definitions
  belongs_to :user

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
end
