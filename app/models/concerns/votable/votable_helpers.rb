module VotableHelpers

  def votable_words
    VotableWords
  end

end



class VotableWords

  def self.that_mean_true
    ['up', 'upvote', 'like', 'liked', 'positive', 'yes', 'good', 'agree', 'true', 1, true]
  end

  def self.that_mean_false
    ['down', 'downvote', 'dislike', 'disliked', 'negative', 'no', 'bad', 'disagree', 'false', 0, false]
  end

  # check is word is a true or bad vote
  # if the word is unknown, then it counts it as a true/good
  # vote.  this exists to allow all voting to be good by default
  def self.meaning_of word
    !that_mean_false.include?(word)
  end

end
