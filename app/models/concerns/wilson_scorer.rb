module WilsonScorer
  extend ActiveSupport::Concern
  # included do
  # end

  # TODO: extract dependency on acts_as_votable cached scores
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

  module ClassMethods
    def bulk_update_wilson_score
      self.all.each do |item|
        item.update_wilson_score
      end
    end

    def order_by_best_wilson_score
      order(wilson_score: :desc, cached_votes_up: :asc, cached_votes_down: :asc)
    end
  end

end
