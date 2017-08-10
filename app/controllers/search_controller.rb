class SearchController < ApplicationController

  def index
    if params[:query]
      @query = params[:query]
      @words = Word.search(@query, [:name])
    else
      flash[:notice] = "No search query provided"
    end
  end

end
