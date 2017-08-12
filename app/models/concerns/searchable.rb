module Searchable
  extend ActiveSupport::Concern

  module ClassMethods

    def search(query, columns)
      self.where(
        columns.map{|c| "#{c} ilike :search" }.join(' OR '),
        search: "%#{query}%"
      )
    end

  end

end
