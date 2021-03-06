class DefinitionsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_word, only: [:new, :create]
  before_action :find_definition, except: [:new, :create]

  def new
    @definition = @word.definitions.build()
  end

  def create
    @definition = @word.definitions.build(definition_params)
    @definition.user_id = current_user.id

    if @definition.save
      redirect_to @word
    else
      redirect_to words_path
    end
  end

  def edit
    if @definition.cannot_be_edited?
      flash[:alert] = "You cannot edit a definition that has been voted on."
      redirect_to @definition.word
    end
  end

  def update
    if @definition.update_attributes(definition_params)
      redirect_to @definition.word
    else
      redirect_to words_path
    end
  end

  def destroy
    if @definition.cannot_be_destroyed?
      flash.now[:alert] = "You cannot delete a definition that has been voted on."
    else
      @definition.destroy
      redirect_to @definition.word
    end
  end

private

  def find_definition
    @definition = Definition.find(params[:id])
  end

  def find_word
    @word = Word.find(params[:word_id])
  end

  def definition_params
    params.require(:definition).permit(:details, :example, :user_id, :word_id)
  end
end
