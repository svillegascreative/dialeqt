class VotesController < ApplicationController
  before_action :authenticate_user!

  def create
    @votable = get_votable
    @votable.toggle_upvote current_user
    @votable.update_wilson_score
    # redirect_to @votable
  end

  def destroy
    @votable = get_votable
    @votable.toggle_downvote current_user
    @votable.update_wilson_score
    # redirect_to @votable
  end

private

  def get_votable
    if params[:word_id]
      Word.find(params[:word_id])
    elsif params[:definition_id]
      Definition.find(params[:definition_id])
    end
  end

end
