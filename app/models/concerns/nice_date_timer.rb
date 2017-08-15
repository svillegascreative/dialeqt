module NiceDateTimer
  extend ActiveSupport::Concern
  # included do
  # end

  def nice_date_format
    "%b %-d '%y"
  end

  def nice_datetime_format
    "%b %-d '%y %l:%M%p"
  end

  def when_created
    created_at.strftime(nice_date_format)
  end

  def when_updated
    updated_at.strftime(nice_date_format)
  end

  def when_if_updated
    if self.updated_at != self.created_at
      "(Edited #{self.when_updated})"
    end
  end

  # module ClassMethods
  # end
end
