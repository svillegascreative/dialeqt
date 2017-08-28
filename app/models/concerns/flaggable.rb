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

  def unflag_by(user)
    if flagged_by?(user)
      flags_by(user).last.destroy
    end
  end

  def toggle_flag_by(user)
    if flagged_by?(user)
      unflag_by(user)
    else
      flag_by(user)
    end
  end

  def flags_by(user)
    flaggings.where(flagger_id: user.id, flagger_type: user.class.to_s)
  end

  def flagged_by?(user)
    flags_by(user).size > 0
  end

  module ClassMethods
    def flagged_by(user)
      Flagging.where(flaggable_type: self.to_s, flagger_id: user.id, flagger_type: user.class.to_s)
    end
  end
end
