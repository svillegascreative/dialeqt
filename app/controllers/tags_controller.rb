class TagsController < ApplicationController
  def index
    @tags = Tag.all.order(name: :asc)
  end

  def show
    @tag = Tag.find(params[:id])
    @words = @tag.words.order(name: :asc)
  end
end
