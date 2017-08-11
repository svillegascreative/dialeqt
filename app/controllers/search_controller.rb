class SearchController < ApplicationController

  def index
    if params[:query].blank?
      flash[:notice] = "No search query provided"
      redirect_to root_url
    else
      @query = params[:query]
      @words = Word.search(@query, [:name])
      @definitions = Definition.search(@query, [:details, :example])
    end
  end

end
