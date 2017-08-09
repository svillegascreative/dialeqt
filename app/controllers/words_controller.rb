class WordsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]

  def index
    @words = Word.all.order(created_at: :desc)
  end

  def show
    find_word
    @definitions = @word.definitions
    @new_definition = Definition.new
  end

  def new
    @word = Word.new
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
    find_word
  end

  def update
    find_word

    if @word.update_attributes(word_params)
      redirect_to @word
    else
      render :edit
    end
  end

  def destroy
    find_word
    @word.destroy
    redirect_to root_url
  end

  def like
    find_word
    if current_user.voted_up_on? @word
      @word.unliked_by current_user
    else
      @word.liked_by current_user
    end
    redirect_to @word
  end

  def dislike
    find_word
    if current_user.voted_down_on? @word
      @word.undisliked_by current_user
    else
      @word.disliked_by current_user
    end
    redirect_to @word
  end

private

  def find_word
    @word = Word.find(params[:id])
  end

  def word_params
    params.require(:word).permit(:name)
  end

end
