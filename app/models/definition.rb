class Definition < ApplicationRecord
  belongs_to :word

  validates :details, presence: true

  acts_as_votable
end
