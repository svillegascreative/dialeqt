class DefinitionsController < ApplicationController
  before_action :authenticate_user!

  def new
    find_word
    @definition = Definition.new
  end

  def create
    find_word
    @definition = Definition.new(definition_params)
    @definition.user_id = current_user.id
    @definition.word = @word

    if @definition.save
      redirect_to @word
    else
      redirect_to words_path
    end
  end

  def edit
    find_definition
  end

  def update
    find_definition

    if @definition.update_attributes(definition_params)
      redirect_to @word
    else
      redirect_to words_path
    end
  end

  def destroy
    find_definition
    @definition.destroy
    redirect_to @word
  end

  def upvote
    find_definition
    @definition.upvote_by current_user
    redirect_to @definition.word
  end

  def downvote
    find_definition
    @definition.downvote_by current_user
    redirect_to @definition.word
  end

private

  def find_definition
    @definition = Definition.find[:id]
  end

  def find_word
    @word = Word.find(params[:word_id])
  end

  def definition_params
    params.require(:definition).permit(:details, :example, :user_id, :word_id)
  end
end
