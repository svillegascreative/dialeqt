module Flaggable
  extend ActiveSupport::Concern

  included do
    has_many :flaggings, as: :flaggable, dependent: :destroy
  end

  def flag_by(user, options = {})
    reason = options[:reason] || nil
    comment = options[:comment] || nil
    flaggings.build(flagger_id: user.id, flagger_type: user.class, reason: reason, comment: comment)
  end

  module ClassMethods
    def flagged_by(user)
      Flagging.where(flaggable_type: self.to_s, flagger_id: user.id, flagger_type: user.class.to_s)
    end
  end
end
