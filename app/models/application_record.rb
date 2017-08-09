class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  # Use only on models with acts_as_votable
  def self.sort_by_wilson_score
    self.all.sort_by(&:wilson_score).reverse
  end

  def wilson_score
    positive = self.get_upvotes.size
    total = self.votes_for.size
    if total == 0
      return 0
    else
      WilsonScore.lower_bound(positive, total)
    end
  end
end
