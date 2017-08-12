class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def when_created
    self.created_at.strftime("%b %-d '%y")
  end

  def when_updated
    self.updated_at.strftime("%b %-d '%y")
  end

  def when_if_updated
    if self.updated_at != self.created_at
      "(Edited #{self.when_updated})"
    end
  end

  # Use only on models with acts_as_votable
  def get_wilson_score
    positive = self.cached_votes_up
    total = self.cached_votes_total
    if total == 0
      return 0
    else
      WilsonScore.lower_bound(positive, total)
    end
  end

  def update_wilson_score
    score = self.get_wilson_score
    self.update(wilson_score: score)
  end
end
