class Definition < ApplicationRecord
  belongs_to :word

  validates :details, presence: true
end
