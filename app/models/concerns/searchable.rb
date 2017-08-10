module Searchable
  extend ActiveSupport::Concern

  module ClassMethods

    def self.search(query, columns)
      self.where(
        columns.map{|c| "#{c} ilike :search" }.join(' OR '),
        search: "%#{query}%"
      )
    end

  end

end
