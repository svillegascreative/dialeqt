class WordsController < ApplicationController

  def index
    @words = Word.all
  end

  def show
    find_word
  end

  def new
    @word = Word.new
  end

  def create
    @word = Word.new(word_params)

    if @word.save
      redirect_to word_url
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

private

  def find_word
    @word = Word.find(params[:id])
  end

  def word_params
    params.require(:word).permit(:word)
  end

end
