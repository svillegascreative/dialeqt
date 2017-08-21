class WordsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_word, except: [:index, :new, :check, :create]

  def index
    @words = Word.all.order_by_best_wilson_score
  end

  def show
    @related_words = Word.fuzzy_search(@word.name).where.not(name: @word.name)
    @definitions = @word.definitions.order_by_best_wilson_score
    @new_definition = Definition.new
  end

  def new
  end

  def check
    if params[:name].blank?
      flash.now[:alert] = "You did not provide any word!"
      render :new
    else
      @checked_words = Word.fuzzy_search(params[:name])
      @word_name = (params[:name])
      @word = Word.new
      3.times {@word.tags.build}
    end
  end

  def create
    @word = Word.new(word_params)
    @word.user_id = current_user.id

    if @word.save
      redirect_to @word
    else
      render :new
    end
  end

  def edit
    if @word.cannot_be_edited?
      flash[:alert] = "You cannot edit a word that has votes or definitions."
      redirect_to @word
    end
  end

  def update
    if @word.update_attributes(word_params)
      redirect_to @word
    else
      render :edit
    end
  end

  def destroy
    if @word.cannot_be_destroyed?
      flash[:alert] = "You cannot delete a word that has votes or definitions."
      redirect_to @word
    else
      @word.destroy
      redirect_to root_url
    end
  end

  def like
    @word.toggle_upvote current_user
    @word.update_wilson_score
    redirect_to @word
  end

  def dislike
    @word.toggle_downvote current_user
    @word.update_wilson_score
    redirect_to @word
  end

private

  def find_word
    @word = Word.find(params[:id])
  end

  def word_params
    params.require(:word).permit(:name, tags_attributes: [:name, :_destroy])
  end

end
