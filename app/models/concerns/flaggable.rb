module Flaggable
  extend ActiveSupport::Concern

  included do
    has_many :flaggings, as: :flaggable, dependent: :destroy
  end
end
