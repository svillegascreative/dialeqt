class VotesController < ApplicationController
  before_action :authenticate_user!

  def create
    @votable = get_votable
    @votable.toggle_upvote current_user
    @votable.update_wilson_score
    redirect_back fallback_location: root_url
  end

  def destroy
    @votable = get_votable
    @votable.toggle_downvote current_user
    @votable.update_wilson_score
    redirect_back fallback_location: root_url
  end

private

  def get_votable
    if model = params.keys.find { |k| k.end_with? "_id"}
      klass = model.chomp("_id").capitalize.constantize
      klass.find(params["#{model}"])
    end
  end

end
