class DefinitionsController < ApplicationController
  before_action :authenticate_user!

  def new
    @definition = Definition.new
  end

  def create
    @definition = Definition.new(definition_params)
    find_word
    @definition.word_id = @word.id
    @definition.user_id = current_user.id

    if @definition.save
      redirect_to @word
    else
      render :new
    end
  end

  def edit
    find_definition
  end

  def update
    find_definition

    if @definition.update_attributes(definition_params)
      redirect_to @definition
    else
      render :edit
    end
  end

  def destroy
    find_definition
    @definition.destroy
    redirect_to @word
  end

private

  def find_definition
    @definition = Definition.find[:id]
  end

  def find_word
    @word = Word.find[:id]
  end

  def definition_params
    require(:deifnition).permit(:details, :example, :user_id, :word_id)
  end
end
