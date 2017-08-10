class Definition < ApplicationRecord
  belongs_to :word
  belongs_to :user

  validates :details, presence: true

  acts_as_votable
end
