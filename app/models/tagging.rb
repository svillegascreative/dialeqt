class Tagging < ApplicationRecord
  belongs_to :word
  belongs_to :tag
end
