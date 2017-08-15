class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def when_created
    self.created_at.strftime("%b %-d '%y")
  end

  def when_updated
    self.updated_at.strftime("%b %-d '%y")
  end

  def when_if_updated
    if self.updated_at != self.created_at
      "(Edited #{self.when_updated})"
    end
  end

end
