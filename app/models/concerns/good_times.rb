module GoodTimes
  extend ActiveSupport::Concern
  # included do
  # end

  @friendly_date = "%b %-d '%y"
  @friendly_datetime = "%b %-d '%y %l:%M%p"

  def when_created
    self.created_at.strftime(@friendly_date)
  end

  def when_updated
    self.updated_at.strftime(@friendly_date)
  end

  def when_if_updated
    if self.updated_at != self.created_at
      "(Edited #{self.when_updated})"
    end
  end

  # module ClassMethods
  # end
end
