class Flagging < ApplicationRecord
  belongs_to :flaggable, polymorphic: true
end
