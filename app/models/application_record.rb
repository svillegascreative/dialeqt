class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

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
