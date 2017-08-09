class Word < ApplicationRecord
  has_many :definitions

  acts_as_votable

  acts_as_url :name,
    url_attribute: :slug,
    sync_url: true,
    blacklist: %W{new edit},
    blacklist_policy: :blacklist_policy

  def self.find(input)
    find_by_slug(input)
  end

  def blacklist_policy
    Proc.new {|w| "word-#{w}"}
  end
end
