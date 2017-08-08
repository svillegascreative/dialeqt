class Word < ApplicationRecord
  has_many :definitions

  acts_as_votable
end
