class WordsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_word, except: [:index, :new, :check, :create]

  def index
    if params[:undefined].present?
      @words = Word.undefined
    elsif params[:recent].present?
      @words = Word.recent
    else
      @words = Word.all.order_by_best_wilson_score
    end
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
      @word.tags.build
    end
  end

  def create
    @word = Word.new(word_params)
    @word.user_id = current_user.id
    @word.tags = Tag.find_or_initialize_by(params[:tags_attributes]) if params[:tags_attributes]

    if @word.save
      redirect_to @word
    else
      render :new
    end
  end

  def edit
    @word.tags.build
  end

  def update
    tag_name = params[:word][:tags_attributes]["#{@word.tags.length}"][:name]
    @word.tags << Tag.find_or_initialize_by(name: tag_name) unless tag_name.blank?
    if @word.update_attributes(word_params)
      redirect_to @word
    else
      render :edit
    end
  end

  def destroy
    if @word.has_votes_or_definitions?
      flash[:alert] = "You cannot delete a word that has votes or definitions."
      redirect_to @word
    else
      @word.destroy
      redirect_to root_url
    end
  end

private

  def find_word
    @word = Word.find(params[:id])
  end

  def word_params
    params.require(:word).permit(:name, tags_attributes: [:id, :name, :_destroy])
  end

end
